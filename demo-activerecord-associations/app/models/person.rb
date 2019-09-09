# frozen_string_literal: true

# Superclass
class Person < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :user, :type, presence: true
end
