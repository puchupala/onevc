require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'
require 'NodeType'

module OpenNebula
    class VirtualCluster
    
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
    
        def create_node(config)
            node = NodeType.new(@client)
            node.allocate(@id, config)
        end
        
        def valid_hierarchy?(node_types)
            require 'rgl/adjacency'
            require 'rgl/topsort' # For acyclic?()
            node_types.each do |node_type|
                # TODO: Code me
            end
            true
        end
    
        public

        def allocate(file)
            config = Configuration.new(file)
            
            return Error.new('Invalid hierarchy detected') unless valid_hierarchy?(config[:NODE_TYPE])
                
            # Create new VC in the database
            @db[:vc_pool].insert(
                :name => config[:VC_NAME].gsub(/^["|'](.*?)["|']$/,'\1'),
                :body => File.read(file)
            )
            
            # Set @id to newly created vcid for the instance
            @id = @db[:vc_pool].order(:oid.desc).first[:oid]
        
            config[:NODE_TYPE].each do |node_type|
                create_node(node_type)
            end
        
            return @id
        end
    
        # TODO: Resolve and use Node Type Hierachy
        def deploy()
            return Error.new('ID not defined') unless @id
            
            node_types().each do |node_type|
                node_type = NodeType.new(@client, node_type[:oid])
                node_type.set_action("DEPLOY")
                
                # node_type = NodeType.new(@client, node_type[:oid])
                # res = node_type.deploy("#{name()}-#{node_type.name}")
                # if OpenNebula.is_error?(res)
                #     return res
                # end
            end
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
                return @db[:node_types].filter(:vcid=>@id).all
            end
        end
    
        # Adapted from PoolElement.info and derevetives
        # Needed to make this class compatible with one_helper
        def info()
            @pe_id = @id.to_i if @id
            return nil
        end
    
    end
end