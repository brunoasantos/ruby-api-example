class Api
  namespace :auth do
    desc 'Authenticate user',
      success: [201, Entities::Token],
      failure: [400, 403, 404],
      auth: false
    params do
      requires :email,      type: String, desc: 'User email'
      requires :password,   type: String, desc: 'User password'
    end
    post do
      result = Services::AuthenticateUser.call(params)
      present result, with: Entities::Token
    end
  end
end
