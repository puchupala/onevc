require 'onedb/Configuration'
require 'onedb/onedb_backend'

class VirtualCluster
    
protected

    def initialize()
        read_onedconf
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

    # No purpose, for compatibility with OneHelper
    def allocate(file)
        config = Configuration.new(file)
        # TODO: Code Me
        @id = 1101
    end

    def id
        @id
    end
    
end