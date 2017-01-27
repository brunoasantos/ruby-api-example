class Api
  module Exceptions
    class ValidationError < StandardError
      attr_reader :errors

      def initialize(msg = 'Validation Error', errors = {})
        @errors = errors
        super(msg)
      end
    end
  end
end
