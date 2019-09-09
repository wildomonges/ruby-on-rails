# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user_owner, class: :User do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    business_name { 'mock_business_name' }
    ruc { '1000000-0' }
    activity { 'mock_activity' }
    plan { FactoryBot.build(:plan) }
    password { 'mock_password' }
    password_confirmation { 'mock_password' }
    user_type { 'business_owner' }
  end

  factory :user_collaborator, class: :User do
    username { Faker::Name.name }
    password { 'thecollaboratorpassword' }
    password_confirmation { 'thecollaboratorpassword'}
    user_type { 'business_collaborator' }
    email { Faker::Internet.email }
  end
end
