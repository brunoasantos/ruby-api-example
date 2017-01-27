require 'spec_helper'

describe Api::Services::GetUser do
  let(:user) { create(:user) }

  context 'success' do
    it 'should return user' do
      expect(described_class.call(user.id)).to eq(user)
    end
  end

  context 'failure' do
    it 'should raise error if user is not found' do
      expect { described_class.call(0) }.to raise_error(Api::Exceptions::NotFoundError)
    end
  end
end
