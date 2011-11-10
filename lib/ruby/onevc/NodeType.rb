require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'

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

public

    # TODO: Validate tid
    # TODO: Support node type hierarchy
    def allocate(vcid, config)
        @db[:node_types].insert(
            :name   => config["NAME"].gsub(/^["|'](.*?)["|']$/,'\1'),
            :body   => Marshal.dump(config),
            :vcid   => vcid,
            :tid    => config["TEMPLATE_ID"],
            :number => config["NUMBER"]
        )
        
        # Set ntid and return
        @id = @db[:node_types].order(:oid.desc).first[:oid]
    end

    def id
        @id
    end
    
end