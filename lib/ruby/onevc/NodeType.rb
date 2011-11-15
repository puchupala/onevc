require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'

module OpenNebula
    class NodeType
    
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

    public

        # TODO: Validate tid
        # TODO: Support node type hierarchy
        def allocate(vcid, config)
            @db[:node_types].insert(
                :name     => config["NAME"].gsub(/^["|'](.*?)["|']$/,'\1'),
                :body     => Marshal.dump(config),
                :vcid     => vcid,
                :tid      => config["TEMPLATE_ID"],
                :number   => config["NUMBER"],
                :nt_state => NT_STATE.index("PENDING")
            )
        
            # Set ntid and return
            @id = @db[:node_types].order(:oid.desc).first[:oid]
        end
    
        def deploy(name)
            count = 0
            res = nil # To extend scope of res
            number().times do
                res = OpenNebula::Template.new_with_id(tid(), @client).instantiate("#{name}-#{count}")
                if OpenNebula.is_error?(res)
                    # NOTE: Do we really want to output this here?
                    puts "Template #{tid()} instantiation return the following error"
                    return res
                end
                count += 1
            end
            res
        end

        def id
            @id
        end
    
        def name
            if @name != nil
                return @name
            else
                return @db[:node_types].filter(:oid=>@id).first[:name]
            end
        end
    
        def number
            if @number != nil
                return @number
            else
                return @db[:node_types].filter(:oid=>@id).first[:number].to_i
            end
        end
    
        def tid
            if @tid != nil
                return @tid
            else
                return @db[:node_types].filter(:oid=>@id).first[:tid].to_i
            end
        end
    
    end
end