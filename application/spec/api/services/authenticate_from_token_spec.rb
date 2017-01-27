require 'spec_helper'

describe Api::Services::AuthenticateFromToken do
  let(:params) { {email: 'foo@bar.com', password: '123secret'} }

  context 'success' do
    it 'should authenticate user with token' do
      user   = create(:user, params)
      token  = Api::Services::AuthenticateUser.call(params)
      result = described_class.call(token)

      expect(result).to eq(user)
    end
  end

  context 'failure' do
    it 'should raise error if token is invalid' do
      expect { described_class.call(token: 'loremipsum') }.to raise_error(JWT::DecodeError)
    end

    it 'should raise error if token is expired' do
      user = create(:user)
      payload = {user_id: user.id, exp: 5.minutes.ago.to_i}
      token   = JWT.encode(payload, HMAC_SECRET)
      expect { described_class.call(token: token) }.to raise_error(JWT::DecodeError)
    end
  end
end
