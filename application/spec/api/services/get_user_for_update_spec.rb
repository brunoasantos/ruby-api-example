require 'spec_helper'

describe Api::Services::GetUserForUpdate do
  let(:user) { create(:user) }

  context 'success' do
    it 'should return user' do
      expect(described_class.call(user, user.id)).to eq(user)
    end
  end

  context 'failure' do
    it 'should raise error if user is not found' do
      expect { described_class.call(user, 0) }.to raise_error(Api::Exceptions::NotFoundError)
    end

    it 'should raise error if user dont have permission' do
      another_user = create(:user)
      expect { described_class.call(user, another_user.id) }.to raise_error(Api::Exceptions::ForbiddenError)
    end
  end
end
