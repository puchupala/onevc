#!/usr/bin/env ruby

require 'OpenNebula'
include OpenNebula
require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'
require 'NodeType'

POLLING_DELAY = 10 # In seconds

loop do
    # Get client and db
    db = OneVCBackend::get_backend().db()    
    client = OpenNebula::Client.new
    
    node_types = db[:node_types].filter(~{:action => NodeType::ACTION.index("NONE")}).all()
    node_types.each do |node_type|
        node_type = NodeType.new(client, node_type[:oid])
    end
        
    # Clean up
    db = nil
    client = nil
    
    sleep(POLLING_DELAY)
end
