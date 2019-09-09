# frozen_string_literal: true

require 'rails_helper'

Rspec.describe AuthenticateUser do
  MOCK_USER_ID = 1
  INVALID_USER_ID = 2
  subject(:context) { AuthenticateUser.call(user_id: MOCK_USER_ID) }

  describe '.call' do
    context 'when given valid session user_id' do
      let(:user) { double(:user, user_id: MOCK_USER_ID) }

      before do
        allow(User).to receive(:authenticate).with(MOCK_USER_ID).and_return(user)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the user' do
        expect(context.user).to eq(user)
      end

      it "provides the user's secret token" do
        expect(context.token).to eq('token')
      end
    end

    context 'when given invalid session user_id' do
      before do
        allow(User).to receive(:authenticate).with(INVALID_USER_ID).and_return(nil)
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides a failure message' do
        expect(context.message).to be_present
      end
    end
  end
end
