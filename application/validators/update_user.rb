class Api
  module Validators
    class UpdateUser
      include Hanami::Validations::Form

      validations do
        required(:first_name).filled(:str?)
        required(:last_name).filled(:str?)
        required(:email).filled(:str?)
        optional(:born_on).filled(:date?)
      end
    end
  end
end

