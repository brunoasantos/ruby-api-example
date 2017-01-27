class Api
  module Services
    class AuthenticateFromToken
      def self.call(params)
        token   = ::JWT.decode(params[:token], HMAC_SECRET, true)
        user_id = token.first['user_id']

        GetUser.call(user_id)
      end
    end
  end
end
