class Api
  module Services
    class GetUser
      def self.call(user_id)
        user = Models::User[user_id]
        raise Exceptions::NotFoundError.new unless user

        user
      end
    end
  end
end
