require 'onevcd_backend'
require 'logger'

POLLING_DELAY = 10 # In seconds
RETRY_DELAY = 1 # In seconds

if ENV['ONE_LOCATION'] == nil
    LOG_PATH = "/var/log/onevcd.log"
else
    LOG_PATH = ENV['ONE_LOCATION'] + "/var/onevcd.log"
end

loop do
    logger = Logger.new(LOG_PATH, shift_age='daily')
    #logger = Logger.new(STDOUT)

    begin
        backend = OneVCDBackend.new(logger)
        backend.execute
        backend = nil
    rescue Sequel::DatabaseError
        sleep(RETRY_DELAY)
        retry
    end

    logger.close
    sleep(POLLING_DELAY)
end
