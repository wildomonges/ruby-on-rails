# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :plan, class: :Plan do
    name { 'basico' }
    max_customers { 5 }
    max_collaborators { 5 }
    price { 0 }
  end
end
