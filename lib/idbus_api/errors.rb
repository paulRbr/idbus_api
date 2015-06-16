module IdbusApi

  # All errors from this gem will inherit from this one.
  class Error < StandardError
    # Returns the appropriate IdbusApi::Error subclass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [IdbusApi::Error]
    def self.from_response(response)
      status  = response[:status].to_i
      body    = response[:body].to_s
      headers = response[:response_headers]

      if klass =  case status
                  when 400      then IdbusApi::BadRequest
                  when 401      then IdbusApi::Unauthorized
                  when 403      then IdbusApi::Unauthorized
                  when 404      then IdbusApi::NotFound
                  when 405      then IdbusApi::MethodNotAllowed
                  when 406      then IdbusApi::NotAcceptable
                  when 409      then IdbusApi::Conflict
                  when 415      then IdbusApi::UnsupportedMediaType
                  when 422      then IdbusApi::UnprocessableEntity
                  when 400..499 then IdbusApi::ClientError
                  when 500      then IdbusApi::InternalServerError
                  when 501      then IdbusApi::NotImplemented
                  when 502      then IdbusApi::BadGateway
                  when 503      then IdbusApi::ServiceUnavailable
                  when 500..599 then IdbusApi::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end
  end

  class ClientError < Error; end
  class BadRequest < ClientError; end
  class Unauthorized < ClientError; end
  class Unauthorized < ClientError; end
  class NotFound < ClientError; end
  class MethodNotAllowed < ClientError; end
  class NotAcceptable < ClientError; end
  class Conflict < ClientError; end
  class UnsupportedMediaType < ClientError; end
  class UnprocessableEntity < ClientError; end
  class InternalServerError < ClientError; end
  class NotImplemented < ClientError; end
  class BadGateway < ClientError; end
  class ServiceUnavailable < ClientError; end
  class ServerError < ClientError; end

end
