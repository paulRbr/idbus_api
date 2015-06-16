require 'idbus_api/response/raise_error'

module IdbusApi

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = "https://api.idbus.com".freeze

    # Default API version
    API_VERSION = "v1".freeze

    # Default User Agent header string
    USER_AGENT   = "Idbus API Ruby Gem #{IdbusApi::VERSION}".freeze

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[IdbusApi::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['IDBUS_ACCESS_TOKEN']
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['IDBUS_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default API version from ENV or {API_VERSION}
      # @return [String]
      def api_version
        ENV['IDBUS_API_VERSION'] || API_VERSION
      end

     # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :user_agent => user_agent
          }
        }
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['IDBUS_USER_AGENT'] || USER_AGENT
      end

    end
  end
end
