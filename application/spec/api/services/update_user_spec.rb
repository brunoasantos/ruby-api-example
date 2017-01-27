require 'spec_helper'

describe Api::Services::UpdateUser do
  let!(:user) do
    create(:user, first_name: 'Foo', last_name: 'Bar', email: 'foo@example.com', password: '123secret', born_on: Date.today)
  end

  context 'success' do
    it 'should update user email' do
      params = {
        email: 'bar@example.com',
        id: user.id
      }
      updated = described_class.call(user, params)
      expect(updated.email).to eq(params[:email])
    end

  end

  context 'failure' do
    it 'should validate that fields are not empty' do
      params = {
        first_name: '',
        last_name:  nil,
        email:      '',
        password:   nil,
        id: user.id
      }
      expect { described_class.call(user, params) }.to raise_error(Api::Exceptions::ValidationError)
    end

    it 'should validate fields types' do
      params = {
        first_name: {foo: :bar},
        last_name:  ['foo', 123],
        email:      {foo: :bar},
        password:   ['foo', 123],
        id:         user.id
      }
      expect { described_class.call(user, params) }.to raise_error(Api::Exceptions::ValidationError)
    end

    it 'should raise error if user is not found' do
      params = {first_name: 'foo', id: 0}
      expect { described_class.call(user, params) }.to raise_error(Api::Exceptions::NotFoundError)
    end

    it 'should raise error if user dont have permission' do
      another_user = create(:user)
      params = {first_name: 'foo', id: another_user.id}
      expect { described_class.call(user, params) }.to raise_error(Api::Exceptions::ForbiddenError)
    end
  end
end
