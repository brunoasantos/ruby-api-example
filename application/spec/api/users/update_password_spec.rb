require 'spec_helper'

describe 'PATCH /api/users/:id/reset_password' do
  let(:user)   { create(:user, password: '123secret') }
  let(:params) { {new_password: 'secret123', confirm_password: 'secret123'} }

  context 'success' do
    it 'should update password' do
      login_as(user)
      patch path_for(user.id), params

      updated = Api::Services::GetUser.call(user.id)

      expect(response_status).to             eq(200)
      expect(updated.password_digest).not_to eq(user.password_digest)
    end
  end

  context 'failure' do
    it 'should return error if user dont have permission' do
      login_as(user)
      another_user = create(:user)
      patch path_for(another_user.id), params
      body = response_body

      expect(response_status).to            eq(403)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:forbidden]).to eq('Forbidden')
    end

    it 'should return error if user is not found' do
      login_as(user)
      patch path_for(0), params
      body = response_body

      expect(response_status).to            eq(404)
      expect(body[:errors]).not_to          be_empty
      expect(body[:errors][:not_found]).to eq('Not Found')
    end

    it 'should validate that fields are not empty' do
      login_as(user)
      params = {new_password: '', confirm_password: nil}
      patch path_for(user.id), params
      body = response_body

      expect(response_status).to                  eq(400)
      expect(body[:errors]).not_to                be_empty
      expect(body[:errors][:new_password]).to     eq(['must be filled'])
      expect(body[:errors][:confirm_password]).to eq(['must be filled'])
    end

    it 'should validate fields types' do
      login_as(user)
      params = {new_password: {a: :b}, confirm_password: [1]}
      patch path_for(user.id), params
      body = response_body

      expect(response_status).to                  eq(400)
      expect(body[:errors]).not_to                be_empty
      expect(body[:errors][:new_password]).to     eq(['is invalid'])
      expect(body[:errors][:confirm_password]).to eq(['is invalid'])
    end

    it 'should validate that passwords match' do
      login_as(user)
      params[:confirm_password] = 'foobar'
      patch path_for(user.id), params
      body = response_body

      expect(response_status).to                       eq(400)
      expect(body[:errors]).not_to                     be_empty
      expect(body[:errors][:password_confirmation]).to eq(['must be equal to foobar'])
    end
  end

  def path_for(user_id)
    "api/v1.0/users/#{user_id}/reset_password"
  end
end
