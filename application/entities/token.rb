class Api
  module Entities
    class Token < Grape::Entity
      expose :token, documentation: { type: 'String', desc: 'Authentication token' }
    end
  end
end
