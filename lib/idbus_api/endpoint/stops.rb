module IdbusApi

  module Endpoint

    # Methods of the Stops API
    module Stops

      # Make a call to the GET /stops endpoint
      #
      # @param options [Hash] optional options to pass to the request
      # @return [Array<Sawyer::Resource>]
      def stops(options = {})
        paginate("/stops", options).stops
      end

    end
  end
end
