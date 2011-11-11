require 'one_helper'
require 'VirtualCluster'

class OneVCHelper < OpenNebulaHelper::OneHelper
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
    
    private

    def factory(id=nil)
        VirtualCluster.new(@client, id)
    end

end
