require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'
require 'NodeType'

class VirtualCluster
    
protected

    def initialize()
        read_onedconf
        @db = @backend.db
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
        node = NodeType.new
        node.allocate(@id, config)
    end

public

    # TODO: Complete me
    def allocate(file)
        config = Configuration.new(file)
        
        # Create new VC in the database
        @db[:vc_pool].insert(
            :name => config[:VC_NAME].gsub(/^["|'](.*?)["|']$/,'\1'),
            :body => File.read(file)
        )
        
        # Set vcid for the instance
        @id = @db[:vc_pool].order(:oid.desc).first[:oid]
        
        config[:NODE_TYPE].each do |node_type|
            create_node(node_type)
        end
        
        return @id
    end

    def id()
        @id
    end
    
end