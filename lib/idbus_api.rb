$LOAD_PATH.unshift(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) || $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'json'

require 'idbus_api/errors'
require 'idbus_api/default'
require 'idbus_api/configurable'
require 'idbus_api/client'
#require 'idbus_api/base'
#require 'idbus_api/stop'
#require 'idbus_api/fare'
require 'idbus_api/version'


# Ruby toolkit for the iDBUS API
module IdbusApi

  class << self
    include IdbusApi::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [IdbusApi::Client] API wrapper
    def client
      return @client if defined?(@client) && @client.same_options?(options)
      @client = IdbusApi::Client.new(options)
    end

    private

    def respond_to_missing?(method_name, include_private=false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        return client.send(method_name, *args, &block)
      end

      super
    end

  end
end

IdbusApi.reset!
