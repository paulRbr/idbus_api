require 'faraday'
require 'idbus_api/errors'

module IdbusApi
  # Faraday response middleware
  module Response

    # This class raises an IdbusApi-flavored exception based
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = IdbusApi::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
