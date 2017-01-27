require 'spec_helper'

describe 'POST /api/users' do
  before(:all) do
    user = create(:user)
    login_as(user)
  end

  context 'success' do
    it 'should create a new user with dob' do
      params = attributes_for(:user)
      post 'api/v1.0/users', params

      body = response_body

      expect(response_status).to     eq(201)
      expect(body[:id]).not_to       be_nil
      expect(body[:first_name]).to   eq(params[:first_name])
      expect(body[:last_name]).to    eq(params[:last_name])
      expect(body[:email]).to        eq(params[:email])
      expect(body[:born_on].to_date).to eq(params[:born_on])
    end

    it 'should create a new user without dob' do
      params = attributes_for(:user)
      params.delete(:born_on)
      post 'api/v1.0/users', params

      body = response_body

      expect(response_status).to   eq(201)
      expect(body[:id]).not_to     be_nil
      expect(body[:first_name]).to eq(params[:first_name])
      expect(body[:last_name]).to  eq(params[:last_name])
      expect(body[:email]).to      eq(params[:email])
      expect(body[:born_on]).to    be_nil
    end
  end

  context 'failure' do
    it 'should validate that required fields are present' do
      post 'api/v1.0/users', {}
      body = response_body

      expect(response_status).to            eq(400)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:first_name]).to eq(['is missing'])
      expect(body[:errors][:last_name]).to  eq(['is missing'])
      expect(body[:errors][:email]).to      eq(['is missing'])
      expect(body[:errors][:password]).to   eq(['is missing'])
    end

    it 'should validate that fileds are not empty' do
      params = {
        first_name: '',
        last_name:  nil,
        email:      '',
        password:   nil
      }
      post 'api/v1.0/users', params
      body = response_body

      expect(response_status).to            eq(400)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:first_name]).to eq(['must be filled'])
      expect(body[:errors][:last_name]).to  eq(['must be filled'])
      expect(body[:errors][:email]).to      eq(['must be filled'])
      expect(body[:errors][:password]).to   eq(['must be filled'])
    end

    it 'should validate fields types' do
      params = {
        first_name: {foo: :bar},
        last_name:  ['foo', 123],
        email:      {foo: :bar},
        password:   ['foo', 123]
      }
      post 'api/v1.0/users', params
      body = response_body

      expect(response_status).to            eq(400)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:first_name]).to eq(['is invalid'])
      expect(body[:errors][:last_name]).to  eq(['is invalid'])
      expect(body[:errors][:email]).to      eq(['is invalid'])
      expect(body[:errors][:password]).to   eq(['is invalid'])
    end
  end
end
