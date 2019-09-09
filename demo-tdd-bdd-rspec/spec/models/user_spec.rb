# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid (user owner) factory' do
    expect(build(:user_owner)).to be_valid
  end
  it 'has a valid (user collaborator) factory' do
    expect(build(:user_collaborator)).to be_valid  
  end

  describe 'Associations' do
    it { should have_many :customers }
    it { should have_many :collaborators }
    it { should have_many :documents }
    it { should have_many :diary_books }
    it { should have_many :ledgers }
    it { should have_many :balance_suma_saldos }
    it { should have_many :balance_generals }

    it { should belong_to :parent }
    it { should belong_to :plan }
  end

  describe 'validation - ' do
    context 'required attributes -' do
      it { should validate_presence_of :password }
      it { should validate_presence_of :password_confirmation }
      it { should validate_presence_of :email }
      it { should validate_presence_of :ruc }
      it { should validate_presence_of :activity }
      it { should validate_presence_of :plan }
      it { should validate_presence_of :username }
      it { should validate_presence_of :user_type }
      it { should validate_presence_of :status }
      it { should validate_presence_of :business_type }

      it { should validate_length_of(:password).is_at_least(6).is_at_most(128).on(%i[create update]) }
      it { should validate_length_of(:password_confirmation).is_at_least(6).is_at_most(128).on(%i[create update]) }

      let(:user) { create(:user_owner) }
      it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
      it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
    end
  end

  describe 'user -' do
    context '(owner) is not valid - ' do
      let(:user) { build(:user_owner) }

      it 'without password' do
        user.password = nil
        expect(user).to_not be_valid
      end
      it 'without password confirmation' do
        user.password_confirmation = nil
        expect(user).to_not be_valid
      end
      it 'without email' do
        user.email = nil
        expect(user).to_not be_valid
      end
      it 'without ruc' do
        user.ruc = nil
        expect(user).to_not be_valid
      end
      it 'without activity' do
        user.activity = nil
        expect(user).to_not be_valid
      end
      it 'without plan' do
        user.plan = nil
        expect(user).to_not be_valid
      end
    end
  end

  describe 'user -' do
    context '(collaborator) is not valid -' do
      let(:user) { build(:user_collaborator) }
      it 'without username' do
        user.username = nil
        expect(user).to_not be_valid
      end
      it 'without password' do
        user.password = nil
        expect(user).to_not be_valid
      end
      it 'without password confirmation' do
        user.password_confirmation = nil
        expect(user).to_not be_valid
      end
    end
  end

  describe 'scopes' do
    it 'return active_collaborator' do
      user = create(:user_owner)
      collaborator = create(:user_collaborator, parent: user)
      expect(user.collaborators.first).to eq(collaborator)
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      let(:user) { build(:user_owner) }
      it { expect(user).to respond_to(:activate!) }
      it { expect(user).to respond_to(:deactivate!) }
      it { expect(user).to respond_to(:active_for_authentication?) }
      it { expect(user).to respond_to(:my_collaborator?) }
      it { expect(user).to respond_to(:can_edit?) }
      it { expect(user).to respond_to(:can_update?) }
      it { expect(user).to respond_to(:can_show?) }
      it { expect(user).to respond_to(:can_new?) }
      it { expect(user).to respond_to(:can_create?) }
    end
  end
end
