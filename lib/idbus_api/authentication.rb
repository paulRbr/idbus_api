module IdbusApi

  # Authentication methods for {IdbusApi::Client}
  module Authentication

    # Indicates if the client was supplied an
    # access token
    #
    # @return [Boolean]
    def token_authenticated?
      !!@access_token
    end

  end
end
