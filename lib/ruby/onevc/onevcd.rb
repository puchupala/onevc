require 'onevcd_backend'

POLLING_DELAY = 10 # In seconds
RETRY_DELAY = 1 # In seconds
    
loop do
    begin
        backend = OneVCDBackend.new
        backend.execute
        backend = nil
    rescue SQLite3::CantOpenException
        sleep(RETRY_DELAY)
        retry
    end
    sleep(POLLING_DELAY)
end
