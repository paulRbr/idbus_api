module IdbusApi

  # Configuration options for {Client}, defaulting to values
  # in {Default}
  module Configurable
    # @!attribute [w] access_token
    #   @see https://api.idbus.com/
    #   @return [String] access token for authentication
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: https://api.idbus.com/
    # @!attribute api_version
    #   @return [String] Version of the api. default: v1
    # @!attribute connection_options
    #   @see https://github.com/lostisland/faraday
    #   @return [Hash] Configure connection options for Faraday
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.

    attr_accessor :access_token, :connection_options, :user_agent
    attr_writer :api_endpoint, :api_version

    class << self

      # List of configurable keys for {IdbusApi::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :api_version,
          :connection_options,
          :user_agent,
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

   # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end
    # Reset configuration options to default values
    def reset!
      IdbusApi::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", IdbusApi::Default.options[key])
      end
      self
    end

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    def api_version
      File.join(@api_version, "")
    end

    private

    def options
      Hash[IdbusApi::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end
