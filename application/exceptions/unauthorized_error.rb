class Api
  module Exceptions
    class UnauthorizedError < StandardError
      attr_reader :errors

      def initialize(msg = 'Unauthorized', errors = {})
        @errors = errors
        super(msg)
      end
    end
  end
end
