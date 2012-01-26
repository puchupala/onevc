require 'one_helper'
require 'VirtualCluster'
require 'VirtualClusterPool'

class OneVCHelper < OpenNebulaHelper::OneHelper
    RETRY_DELAY = 1 # In seconds
    
    NODE_TYPE_ID = {
        :name        => "node_type_id",
        :short       => "-n node_type_id",
        :large       => "--node node_type_id",
        :format      => String,
        :description => "ID of the Node type"
    }


    def self.rname
        "VC"
    end

    def self.conf_file
        "onevc.yaml"
    end
    
    # Overridden list_pool method of one_helper.rb
    def list_pool(options, top=false, filter_flag=nil)
        filter_flag ||= OpenNebula::Pool::INFO_GROUP # Unused
        
        table = format_pool(options)
        
        if top
            begin
                table.top(options) do
                        pool = factory_pool(filter_flag) # Not sure if this help CantOpenException problem
                        pool.info
                        pool.to_array
                end
            rescue Sequel::DatabaseError
                sleep(RETRY_DELAY)
                puts "RETRYING"
                retry
            end
        else
            table.show(factory_pool(filter_flag).to_array())
        end
        
        return 0
    end
    
    private

    def factory(id=nil)
        VirtualCluster.new(@client, id)
    end
    
    def factory_pool(user_flag=-2)
        OpenNebula::VirtualClusterPool.new(@client, user_flag)
    end
            
    def format_pool(options)
        config_file = self.class.table_conf
        
        table = CLIHelper::ShowTable.new(config_file, self) do
            column :TYPE, "Type of the Virtual Cluster element", :size=>6 do |d|
                d["TYPE"]
            end
            
            column :ID, "ONE identifier for Virtual Cluster", :size=>6 do |d|
                d["ID"]
            end
            
            column :NAME, "Name of the Virtual Cluster", :left, :size=>15 do |d|
                d["NAME"]
            end
            
            column :STAT, "Actual status", :size=>4 do |d|
                d["STAT"]
            end
            
            default :TYPE, :ID, :NAME, :STAT
        end
        
        table
    end

end
