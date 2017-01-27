class Api
  module Services
    class AuthenticateFromToken
      def self.call(params)
        token   = ::JWT.decode(params[:token], HMAC_SECRET, true)
        user_id = token.first['user_id']

        user = Models::User[user_id]
        raise Exceptions::NotFoundError.new unless user

        user
      end
    end
  end
end
