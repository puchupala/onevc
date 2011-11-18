require 'onevcd_backend'

POLLING_DELAY = 10 # In seconds
    
loop do
    backend = OneVCDBackend.new
    backend.execute
    backend = nil
    sleep(POLLING_DELAY)
end
