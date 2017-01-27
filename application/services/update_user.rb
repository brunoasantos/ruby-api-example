class Api
  module Services
    class UpdateUser
      def self.call(current_user, params)
        user = Models::User[params[:id]]
        raise Exceptions::NotFoundError.new unless user
        raise Exceptions::ForbiddenError.new unless current_user.can?(:edit, user)

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
