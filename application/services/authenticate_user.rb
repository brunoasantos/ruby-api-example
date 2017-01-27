class Api
  module Services
    class AuthenticateUser
      def self.call(params)
        user = Models::User.first(email: params[:email])
        raise Exceptions::NotFoundError.new unless user
        raise Exceptions::UnauthorizedError.new unless user.authenticate(params[:password])

        payload = {
          user_id: user.id,
          exp:     6.hours.from_now.to_i
        }
        {token: JWT.encode(payload, HMAC_SECRET)}
      end
    end
  end
end
