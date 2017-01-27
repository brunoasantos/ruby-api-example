class Api
  module Services
    class GetUserForUpdate
      def self.call(current_user, user_id)
        user = GetUser.call(user_id)
        raise Exceptions::ForbiddenError.new unless current_user.can?(:edit, user)

        user
      end
    end
  end
end
