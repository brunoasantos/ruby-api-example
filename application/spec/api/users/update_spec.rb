require 'spec_helper'

describe 'UPDATE /api/users/:id' do
  let(:user) { create(:user) }

  context 'success' do
    it 'should update user' do
      login_as(user)
      params = {email: 'changed_email@domain.com'}
      put path_for(user.id), params

      body = response_body

      expect(response_status).to   eq(200)
      expect(body[:id]).to         eq(user.id)
      expect(body[:first_name]).to eq(user.first_name)
      expect(body[:last_name]).to  eq(user.last_name)
      expect(body[:email]).to      eq(params[:email])
      expect(body[:born_on]).to    eq(user.born_on.to_date.iso8601)
    end
  end

  context 'failure' do
    it 'should return error if user dont have permission' do
      login_as(user)
      another_user = create(:user)
      params = {first_name: 'foo'}
      put path_for(another_user.id), params
      body = response_body

      expect(response_status).to            eq(403)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:forbidden]).to eq('Forbidden')
    end

    it 'should return error if user is not found' do
      login_as(user)
      params = {first_name: 'foo'}
      put path_for(0), params
      body = response_body

      expect(response_status).to            eq(404)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:not_found]).to eq('Not Found')
    end

    it 'should validate that fileds are not empty' do
      login_as(user)
      params = {
        first_name: '',
        last_name:  nil,
        email:      ''
      }
      put path_for(user.id), params
      body = response_body

      expect(response_status).to            eq(400)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:first_name]).to eq(['must be filled'])
      expect(body[:errors][:last_name]).to  eq(['must be filled'])
      expect(body[:errors][:email]).to      eq(['must be filled'])
    end

    it 'should validate fields types' do
      login_as(user)
      params = {
        first_name: {foo: :bar},
        last_name:  ['foo', 123],
        email:      {foo: :bar}
      }
      put path_for(user.id), params
      body = response_body

      expect(response_status).to            eq(400)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:first_name]).to eq(['is invalid'])
      expect(body[:errors][:last_name]).to  eq(['is invalid'])
      expect(body[:errors][:email]).to      eq(['is invalid'])
    end
  end

  def path_for(user_id)
    "api/v1.0/users/#{user_id}"
  end
end
