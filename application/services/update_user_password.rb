class Api
  module Services
    class UpdateUserPassword
      def self.call(current_user, params)
        user   = GetUserForUpdate.call(current_user, params[:id])
        result = Validators::UpdateUserPassword.new(params).validate
        raise Exceptions::ValidationError.new('Validation Error', result.errors) unless result.success?

        user.update(password: result.output[:new_password])
        Workers::PasswordUpdatedNotification.perform_async(user.id) if user
        user
      end
    end
  end
end
