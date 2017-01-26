class Api
  module Services
    class CreateUser
      def self.call(params)
        result = Validators::CreateUser.new(params).validate
        raise Validators::ValidationError.new('Validation Error', result.errors) unless result.success?

        user = Models::User.create(result.output)
        Workers::AccountCreatedNotification.perform_async(user.id) if user

        user
      end
    end
  end
end
