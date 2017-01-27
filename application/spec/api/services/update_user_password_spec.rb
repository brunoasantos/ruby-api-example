require 'spec_helper'

describe Api::Services::UpdateUserPassword do
  let(:user)   { create(:user, password: '123secret') }
  let(:params) { {new_password: 'secret123', confirm_password: 'secret123', id: user.id} }

  context 'success' do
    it 'should update user password' do
      updated = described_class.call(user, params)
      expect(updated.password_digest).not_to eq(user.password_digest)
    end

    it 'should send an email to the user after password is updated' do
      notifier = Api::Workers::PasswordUpdatedNotification
      expect { described_class.call(user, params) }.to change(notifier.jobs, :size).by(1)
    end
  end

  context 'failure' do
    it 'should validate that fields are not empty' do
      params = {new_password: '', confirm_password: nil, id: user.id}
      expect { described_class.call(user, params) }.to raise_error(Api::Exceptions::ValidationError)
    end

    it 'should validate fields types' do
      params = {new_password: {a: :b}, confirm_password: [1], id: user.id}
      expect { described_class.call(user, params) }.to raise_error(Api::Exceptions::ValidationError)
    end

    it 'should validate that passwords match' do
      params[:confirm_password] = 'foobar'
      expect { described_class.call(user, params) }.to raise_error(Api::Exceptions::ValidationError)
    end
  end
end
