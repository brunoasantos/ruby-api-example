require 'spec_helper'

describe Api::Services::AuthenticateUser do
  let(:params) { {email: 'foo@bar.com', password: '123secret'} }

  context 'success' do
    it 'should create JWT token for user' do
      create(:user, params)
      result = described_class.call(params)
      expect(result[:token]).to be
    end
  end

  context 'failure' do
    it 'should raise error if user is not found' do
      expect { described_class.call(params) }.to raise_error(Api::Exceptions::NotFoundError)
    end

    it 'should raise error if user credentials are wrong' do
      create(:user, params)
      expect { described_class.call(params.merge({password: 'lorem'})) }.to raise_error(Api::Exceptions::UnauthorizedError)
    end
  end
end
