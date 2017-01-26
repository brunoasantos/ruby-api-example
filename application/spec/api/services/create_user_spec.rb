require 'spec_helper'

describe Api::Services::CreateUser do
  context 'success' do
    it 'should create a new user with dob' do
      params = attributes_for(:user)
      user   = described_class.call(params)

      expect(user.id).not_to          be_nil
      expect(user.first_name).to      eq(params[:first_name])
      expect(user.last_name).to       eq(params[:last_name])
      expect(user.email).to           eq(params[:email])
      expect(user.password).to        eq(params[:password])
      expect(user.born_on.to_date).to eq(params[:born_on])
    end

    it 'should create a new user without dob' do
      params = attributes_for(:user)
      params.delete(:born_on)
      user   = described_class.call(params)

      expect(user.id).not_to     be_nil
      expect(user.first_name).to eq(params[:first_name])
      expect(user.last_name).to  eq(params[:last_name])
      expect(user.email).to      eq(params[:email])
      expect(user.password).to   eq(params[:password])
      expect(user.born_on).to    be_nil
    end
  end

  context 'failure' do
    it 'should validate that required fields are present' do
      params = {}
      expect { described_class.call(params) }.to raise_error(Api::Validators::ValidationError)
    end

    it 'should validate that fileds are not empty' do
      params = {
        first_name: '',
        last_name:  nil,
        email:      '',
        password:   nil
      }
      expect { described_class.call(params) }.to raise_error(Api::Validators::ValidationError)
    end

    it 'should validate fields types' do
      params = {
        first_name: {foo: :bar},
        last_name:  ['foo', 123],
        email:      {foo: :bar},
        password:   ['foo', 123]
      }
      expect { described_class.call(params) }.to raise_error(Api::Validators::ValidationError)
    end
  end
end
