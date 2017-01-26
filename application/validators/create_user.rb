class Api
  module Validators
    class CreateUser
      include Hanami::Validations::Form

      validations do
        required(:first_name).filled(:str?)
        required(:last_name).filled(:str?)
        required(:email).filled(:str?)
        required(:password).filled(:str?)
        optional(:born_on).filled(:date?)
      end
    end
  end
end

