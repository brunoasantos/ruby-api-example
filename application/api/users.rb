class Api
  resource :users do
    desc 'List all users',
      success: [200, Entities::User],
      auth: false
    params do
      includes :basic_search
    end
    get do
      users = Models::User.all
      present users, with: Entities::User, root: 'users'
    end

    desc 'Create a new user',
      success: [201, Entities::User],
      failure: [400],
      auth: true

    params do
      requires :first_name, type: String, desc: 'User first name'
      requires :last_name,  type: String, desc: 'User last name'
      requires :email,      type: String, desc: 'User email name'
      requires :password,   type: String, desc: 'User password name'
      optional :born_on,    type: Date,   desc: 'User date of birth'
    end
    post do
      result = Services::CreateUser.call(params)
      present result, with: Entities::User
    end

    desc 'Update a user',
      success: [200, Entities::User],
      failure: [400, 401, 404],
      auth: true
    params do
      optional :first_name, type: String, desc: 'User first name'
      optional :last_name,  type: String, desc: 'User last name'
      optional :email,      type: String, desc: 'User email name'
      optional :born_on,    type: Date,   desc: 'User date of birth'
    end
    put ':id' do
      result = Services::UpdateUser.call(current_user, params)
      present result, with: Entities::User
    end
  end
end
