require 'Configuration'
require 'onedb_backend'

# Extract db object from OneDBBackEnd
class OneDBBacKEnd
    
    public
    
    def db
        connect_db
        return @db
    end
    
end

class OneVCBackend
    
    # Modified from read_onedconf of onedb/onedb.rb
    def self.get_backend()
        config = Configuration.new("#{ETC_LOCATION}/oned.conf")

        if config[:db] == nil
            raise "No DB defined."
        end

        if config[:db]["BACKEND"].upcase.include? "SQLITE"
            sqlite_file = "#{VAR_LOCATION}/one.db"
            backend = BackEndSQLite.new(sqlite_file)
        elsif config[:db]["BACKEND"].upcase.include? "MYSQL"
            backend = BackEndMySQL.new(
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

        return backend
    end
    
end
