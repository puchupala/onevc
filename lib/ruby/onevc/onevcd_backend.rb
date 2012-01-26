require 'OpenNebula'
include OpenNebula
require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'
require 'VirtualCluster'
require 'NodeType'

class OneVCDBackend
    
    protected
    
    def initialize
        @db = OneVCBackend::get_backend().db()    
        @client = OpenNebula::Client.new
        # @node_types = @db[:node_types].filter(~{:action => NodeType::ACTION.index("NONE")}).all()
        @node_types = @db[:node_types].all()
        @vcs = @db[:vc_pool].all()
    end
    
    # TODO: Implement (internal) deployment policy
    def deploy_handle(vc, node_type)
        if node_type.deployable?
            res = node_type.deploy("#{vc.name()}-#{node_type.name}")
            if OpenNebula.is_error?(res)
                # TODO: Handle error
            end
        end
    end

    def suspend_handle(vc, node_type)
        if node_type.suspendable?
            res = node_type.suspend()
            if OpenNebula.is_error?(res)
                # TODO: Handle error
            end
        end
    end

    def stop_handle(vc, node_type)
        if node_type.stoppable?
            res = node_type.stop()
            if OpenNebula.is_error?(res)
                # TODO: Handle error
            end
        end
    end
    
    def resume_handle(vc, node_type)
        # TODO: Code me
    end
    
    def delete_handle(vc, node_type)
        if node_type.deletable?
            res = node_type.delete()
            if OpenNebula.is_error?(res)
                # TODO: Handle error
            end
        # puts "VC: #{vc.id}"
        # puts "NODE_TYPE: #{node_type.id}"
        # TODO: Code me
        end
    end
        
    public
    
    def execute
        @node_types.each do |node_type|
            vc = VirtualCluster.new(@client, node_type[:vcid])
            node_type = NodeType.new(@client, node_type[:oid])
            
            node_type.update()
            
            action = node_type.get_action()
            if action == NodeType::ACTION.index("DEPLOY")
                deploy_handle(vc, node_type)
            elsif action == NodeType::ACTION.index("SUSPEND")
                suspend_handle(vc, node_type)
            elsif action == NodeType::ACTION.index("STOP")
                stop_handle(vc, node_type)
            elsif action == NodeType::ACTION.index("RESUME")
                resume_handle(vc, node_type)
            elsif action == NodeType::ACTION.index("DELETE")
                delete_handle(vc, node_type)
            end
        end
        @vcs.each do |vc|
            vc = VirtualCluster.new(@client, vc[:oid])
            vc.update()
        end
    end
    
end