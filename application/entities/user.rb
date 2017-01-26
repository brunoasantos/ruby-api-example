class Api
  module Entities
    class User < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      expose :id,         documentation: { type: 'Integer', desc: 'User ID'            }
      expose :first_name, documentation: { type: 'String',  desc: 'User first name'    }
      expose :last_name,  documentation: { type: 'String',  desc: 'User last name'     }
      expose :email,      documentation: { type: 'String',  desc: 'User email name'    }
      expose :born_on,    documentation: { type: 'Date',    desc: 'User date of birth' }, if: lambda { |u, o| u.born_on }

      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: { type: 'Timestamp', desc: 'User creation timestamp'    }
        expose :updated_at, documentation: { type: 'Timestamp', desc: 'User last update timestamp' }
      end
    end
  end
end
