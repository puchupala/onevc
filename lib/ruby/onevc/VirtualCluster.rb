require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'
require 'NodeType'
require 'rgl/adjacency'
require 'rgl/topsort' # For acyclic? method

module OpenNebula
    class VirtualCluster
        
        ROOT_NODE_TYPE = "/"
        VC_STATE = NodeType::NT_STATE + ["SHIFTING"]
        SHORT_VC_STATES = NodeType::SHORT_NT_STATES.merge({"SHIFTING" => "shft"})
    
        protected

        # client and id order is swapped
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
    
        def create_node_type(config)
            node = NodeType.new(@client)
            node.allocate(@id, config)
        end
        
        def valid_hierarchy?(node_types)
            tree = VirtualCluster.create_tree(node_types, RGL::DirectedAdjacencyGraph)
            # TODO: Validate hierarchy
            true
        end
    
        public

        def allocate(file)
            config = Configuration.new(file)
            
            return Error.new('Invalid hierarchy detected') unless valid_hierarchy?(config[:NODE_TYPE])
                
            # Create new VC in the database
            @db[:vc_pool].insert(
                :name     => config[:VC_NAME].gsub(/^["|'](.*?)["|']$/,'\1'),
                :body     => File.read(file),
                :vc_state => VC_STATE.index("SHIFTING")
            )
            
            # Set @id to newly created vcid for the instance
            @id = @db[:vc_pool].order(:oid.desc).first[:oid]
                    
            VirtualCluster.sort_by_hierarchy(config[:NODE_TYPE]).each do |node_type|
                res = create_node_type(node_type)
                return res if OpenNebula.is_error?(res)
            end
        
            return @id
        end
    
        # TODO: Resolve and use Node Type Hierachy
        def deploy()
            return Error.new('ID not defined') unless @id
                        
            node_types().each do |node_type|
                node_type.set_action("DEPLOY")
            end
        end
        
        def delete()
            return Error.new('ID not defined') unless @id
            
            node_types().each do |node_type|
                node_type.set_action("DELETE")
            end
        end
        
        def stop()
            return Error.new('ID not defined') unless @id
            return nil unless get_state() == VC_STATE.index("RUNNING")
            
            node_types().each do |node_type|
                node_type.set_action("STOP")
            end
        end
        
        def suspend()
            return Error.new('ID not defined') unless @id
            return nil unless get_state() == VC_STATE.index("RUNNING")
            
            node_types().each do |node_type|
                node_type.set_action("SUSPEND")
            end
        end
        
        def resume()
            return Error.new('ID not defined') unless @id
            return nil unless (get_state() == VC_STATE.index("STOPPED")) || (get_state() == VC_STATE.index("SUSPENDED"))
            
            node_types().each do |node_type|
                node_type.set_action("RESUME")
            end
        end
        
        def running?
            node_types().each do |node_type|
                return false unless node_type.get_state() == NodeType::NT_STATE.index(["RUNNING"])
            end
            true
        end
        
        def set_state(state)
            return Error.new("Unknow action specified") if VC_STATE.index(state) == nil
            @db[:vc_pool].filter(:oid=>@id).update(:vc_state=>VC_STATE.index(state))
        end
        
        def get_state()
            update()
            @db[:vc_pool].filter(:oid=>@id).first[:vc_state].to_i
        end
        
        def get_state_name()
            VC_STATE[get_state]
        end
        
        def compute_state()
            state = node_types[0].get_state()
            node_types.each do |node_type|
                return VC_STATE.index("SHIFTING") unless state == node_type.get_state()
            end
            state
        end
                
        def update()
            set_state(VC_STATE[compute_state()])
        end
        
        def id()
            @id
        end
        
        def name()
            if @name != nil
                return @name
            else
                return @db[:vc_pool].filter(:oid=>@id).first[:name]
            end
        end
        
        def node_types
            if @node_types != nil
                return @node_types
            else
                @node_types = @db[:node_types].filter(:vcid=>@id).all.map { |node_type| NodeType.new(@client, node_type[:oid]) }
            end
        end
    
        # Adapted from PoolElement.info and derevetives
        # Needed to make this class compatible with one_helper
        def info()
            @pe_id = @id.to_i if @id
            return nil
        end
        
        def self.sort_by_hierarchy(node_types)
            tree = VirtualCluster.create_tree(node_types, RGL::DirectedAdjacencyGraph)
            output = []
            
            iterator =  tree.bfs_iterator(ROOT_NODE_TYPE)
            iterator.set_finish_vertex_event_handler do |node_type|
                next if node_type == ROOT_NODE_TYPE
                output += [node_type]
            end
            iterator.set_to_end
            
            output
        end
        
        def self.create_tree(node_types, graph_type, root=ROOT_NODE_TYPE)
            tree = graph_type.new
            node_types.each do |node_type|
                if node_type["PARENT"] == nil
                    tree.add_edge(root, node_type)
                else
                    node_types.each do |nt|
                        if nt["NAME"] == node_type["PARENT"]
                            tree.add_edge(nt, node_type)
                            break
                        end
                    end
                end
            end
            tree
        end
    
    end
end