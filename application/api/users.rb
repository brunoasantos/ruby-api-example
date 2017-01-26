class Api
  resource :users do
    params do
      includes :basic_search
    end
    get do
      users = SEQUEL_DB[:users].all
      {
        data: users
      }
    end

    desc 'Create a new user',
      success: [201, Entities::User],
      failure: [400]
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
  end
end
