require 'api/authentication'
require 'api/configurable'
require 'api/connection'

module IdbusApi

  # Client for the iDBUS API
  #
  # @see https://api.idbus.com
  class Client < Api::Client

    include Api::Authentication
    include Api::Configurable
    include Api::Connection

     # Header keys that can be passed in options hash to {#get}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

  end
end
