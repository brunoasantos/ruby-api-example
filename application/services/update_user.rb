class Api
  module Services
    class UpdateUser
      def self.call(current_user, params)
        user   = GetUserForUpdate.call(current_user, params[:id])
        params = user.values.merge(params.symbolize_keys)
        params[:born_on] = params[:born_on].to_date unless params[:born_on].nil?
        result = Validators::UpdateUser.new(params).validate
        raise Exceptions::ValidationError.new('Validation Error', result.errors) unless result.success?

        user.update(result.output)
        user
      end
    end
  end
end
