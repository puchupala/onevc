module OpenNebula
    class VirtualClusterPool
        
        def initialize(client, user_id=0)
            @user_id = user_id
            @db = OneVCBackend::get_backend().db()
            @client = OpenNebula::Client.new
            @vcs = @db[:vc_pool].all()
        end
        
        # No purpose, needed by modified list_pool just to make it similar to original list_pool
        def info
            nil
        end
        
        def to_array
            results = []
            @vcs.each do |vc|
                vc = VirtualCluster.new(@client, vc[:oid])
                next if vc.get_state() == VirtualCluster::VC_STATE.index("DONE")
                results.push({
                    "TYPE"  => "VC",
                    "ID"    => vc.id,
                    "NAME"  => vc.name,
                    "STAT" => vc.get_state_name.downcase
                })
                vc.node_types.each do |node_type|
                    results.push({
                        "TYPE"  => "NT",
                        "ID"    => node_type.id,
                        "NAME"  => node_type.name,
                        "STAT" => node_type.get_state_name.downcase
                    })
                end
            end
            results
        end
        
    end
end
