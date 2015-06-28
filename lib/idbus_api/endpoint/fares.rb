module IdbusApi

  module Endpoint

    # Methods of the Fares API
    module Fares

      # Make a call to the GET /fares endpoint
      #
      # @param parameters [Hash] optional parameters to pass to the request
      # @return [Array<Sawyer::Resource>]
      def fares(parameters = {})
        allowed_parameters = %i(
          origin_id
          destination_id
          date
          start_date
          end_date
          currencies
          updated_after
        )

        wrong_parameters = parameters.keys - allowed_parameters
        fail IdbusApi::WrongParameters, wrong_parameters unless wrong_parameters.empty?

        paginate("/fares", parameters).fares
      end

    end
  end
end
