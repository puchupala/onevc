#!/usr/bin/env ruby

require 'OpenNebula'
include OpenNebula
require 'Configuration'
require 'onedb_backend'
require 'onevc_backend'

POLLING_DELAY = 10 # In seconds

loop do
    # Get client and db
    db = OneVCBackend::get_backend().db()    
    client = OpenNebula::Client.new
        
    # Clean up
    db = nil
    client = nil
    
    sleep(POLLING_DELAY)
end
