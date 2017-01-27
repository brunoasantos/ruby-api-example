class Api
  module Exceptions
    class NotFoundError < StandardError
      attr_reader :errors

      def initialize(msg = 'Not Found', errors = {})
        @errors = errors
        super(msg)
      end
    end
  end
end
