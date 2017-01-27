class Api
  module Exceptions
    class ForbiddenError < StandardError
      attr_reader :errors

      def initialize(msg = 'Forbidden', errors = {})
        @errors = errors
        super(msg)
      end
    end
  end
end
