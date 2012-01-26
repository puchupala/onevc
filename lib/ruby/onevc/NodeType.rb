require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'

module OpenNebula
    class NodeType
        
        ROOT_ID = -1
    
        #######################################################################
        # Constants and Class Methods
        #######################################################################
        NT_STATE = %w{PENDING RUNNING SUSPENDED STOPPED DONE}
    
        SHORT_NT_STATES = {
            "PENDING"   => "pend",
            "RUNNING"   => "runn",
            "SUSPENDED" => "susp",
            "STOPPED"   => "stop",
            "DONE"      => "done"
        }
        
        ACTION = %w{NONE DEPLOY SUSPEND STOP DELETE}
        
        SHORT_ACTIONS = {
            "NONE"    => "none",
            "DEPLOY"  => "depl",
            "SUSPEND" => "susp",
            "STOP"   => "stop",
            "DELETE"   => "delete"
        }
    
    protected
        def initialize(client, id=nil)
            read_onedconf
            @db = @backend.db
            @client = client
            @id = id
        end
    
        # Taken from onedb/onedb.rb
        def read_onedconf()
            config = Configuration.new("#{ETC_LOCATION}/oned.conf")

            if config[:db] == nil
                raise "No DB defined."
            end
        
            if config[:db]["BACKEND"].upcase.include? "SQLITE"
                sqlite_file = "#{VAR_LOCATION}/one.db"
                @backend = BackEndSQLite.new(sqlite_file)
            elsif config[:db]["BACKEND"].upcase.include? "MYSQL"
                @backend = BackEndMySQL.new(
                    :server  => config[:db]["SERVER"],
                    :port    => config[:db]["PORT"],
                    :user    => config[:db]["USER"],
                    :passwd  => config[:db]["PASSWD"],
                    :db_name => config[:db]["DB_NAME"]
                )
            else
                raise "Could not load DB configuration from " <<
                      "#{ETC_LOCATION}/oned.conf"
            end

            return 0
        end
        
        def create_node(vmid)
            @db[:nodes].insert(
                :vcid => vcid(),
                :ntid  => @id,
                :vmid => vmid
            )
        end

    public

        # TODO: Validate tid
        # TODO: Support template override
        def allocate(vcid, config)
            parent_name = nil
            if config["PARENT"] == nil
                parent_id = ROOT_ID
            else
                parent = @db[:node_types].filter(:vcid=>vcid, :name=>NodeType.strip(config["PARENT"])).first
                return Error.new("Can't find parent node type") if parent == nil
                parent_id = parent[:oid]
            end
                
            @db[:node_types].insert(
                :name     => NodeType.strip(config["NAME"]),
                :body     => Marshal.dump(config),
                :vcid     => vcid,
                :tid      => config["TEMPLATE_ID"],
                :pid      => parent_id,
                :number   => config["NUMBER"],
                :nt_state => NT_STATE.index("PENDING"),
                :action   => ACTION.index("NONE")
            )
        
            # Set ntid and return
            @id = @db[:node_types].order(:oid.desc).first[:oid]
        end
    
        # TODO: Implement (internal) deployment policy
        # TODO: Fill information in node table
        def deploy(name)
            count = 0
            res = nil # To extend scope of res
            number().times do
                vmid = OpenNebula::Template.new_with_id(tid(), @client).instantiate("#{name}-#{count}")
                if OpenNebula.is_error?(vmid)
                    # NOTE: Do we really want to output this here?
                    puts "Template #{tid()} instantiation return the following error"
                    return vmid
                end
                node = create_node(vmid)
                if OpenNebula.is_error?(node)
                    # NOTE: Do we really want to output this here?
                    puts "Error while creating node for VM ID #{vmid}"
                    return node
                end
                count += 1
            end
            set_action("NONE")
            res
        end
        
        def deployable?()
            return true if parent() == ROOT_ID
            return true if parent().get_state() == NT_STATE.index("RUNNING")
            false
        end
        
        def running?()
            # Check node type status
            return true if get_state() == NT_STATE.index("RUNNING")

            # Check number of deployed nodes
            nodes = @db[:nodes].filter(:vcid=>vcid(), :ntid=>@id).all()
            return false if nodes.count < number()

            # Check status of deployed nodes
            nodes.each do |node|
                vm = OpenNebula::VirtualMachine.new_with_id(node[:vmid], @client)
                vm.info # Update vm info
                return false unless vm.lcm_state_str == "RUNNING"
            end

            # Passed!
            true
        end
        
        def set_state(state)
            return Error.new("Unknow state specified") if NT_STATE.index(state) == nil
            @db[:node_types].filter(:oid=>@id).update(:nt_state=>NT_STATE.index(state))
        end
        
        def set_action(action)
            return Error.new("Unknow action specified") if ACTION.index(action) == nil
            @db[:node_types].filter(:oid=>@id).update(:action=>ACTION.index(action))
        end
        
        def get_state()
            @db[:node_types].filter(:oid=>@id).first[:nt_state].to_i
        end
        
        def get_state_name()
            NT_STATE[get_state]
        end
        
        def get_action()
            @db[:node_types].filter(:oid=>@id).first[:action].to_i
        end
        
        def update()
            set_state("RUNNING") if running?()
        end

        def id
            @id
        end
    
        def name
            if @name != nil
                return @name
            else
                return @name = @db[:node_types].filter(:oid=>@id).first[:name]
            end
        end
    
        def number
            if @number != nil
                return @number
            else
                return @number = @db[:node_types].filter(:oid=>@id).first[:number].to_i
            end
        end
    
        def tid
            if @tid != nil
                return @tid
            else
                return @tid = @db[:node_types].filter(:oid=>@id).first[:tid].to_i
            end
        end
        
        def vcid
            if @vcid != nil
                return @vcid
            else
                return @vcid = @db[:node_types].filter(:oid=>@id).first[:vcid].to_i
            end
        end
        
        def parent()
            if @parent != nil
                return @parent
            else
                parent_id = @db[:node_types].filter(:oid=>@id).first[:pid].to_i
                if parent_id == ROOT_ID
                    return ROOT_ID
                else
                    return @parent = NodeType.new(@client, parent_id)                    
                end
            end
        end
                
        def self.strip(string)
            return string.gsub(/^["|'](.*?)["|']$/,'\1')
        end
    
    end
end