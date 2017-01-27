class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods
      def authenticate!
        token = headers['Authorization']
        return current_user if current_user && token.nil?
        raise Exceptions::UnauthorizedError if token.nil?

        @current_user = Services::AuthenticateFromToken.call(token: token)
      end

      def current_user
        @current_user
      end

      def needs_auth?
        self.route.settings[:description][:auth] rescue false
      end
    end
  end
end
