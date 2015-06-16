require 'idbus_api/authentication'
require 'idbus_api/configurable'
require 'idbus_api/connection'

module IdbusApi

  # Client for the iDBUS API
  #
  # @see https://api.idbus.com
  class Client

    include IdbusApi::Authentication
    include IdbusApi::Configurable
    include IdbusApi::Connection

     # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      IdbusApi::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || IdbusApi.instance_variable_get(:"@#{key}"))
      end
    end

    # Set access token for authentication
    #
    # @param value [String] 20 character iDBUS API access token
    def access_token=(value)
      reset_agent
      @access_token = value
    end
  end

end
