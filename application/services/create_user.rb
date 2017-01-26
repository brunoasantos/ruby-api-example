class Api
  module Services
    class CreateUser
      def self.call(params)
        result = Validators::CreateUser.new(params).validate
        raise Validators::ValidationError.new('Validation Error', result.errors) unless result.success?

        Models::User.create(result.output)
      end
    end
  end
end
