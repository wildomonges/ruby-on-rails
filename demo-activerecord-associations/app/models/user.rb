# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :country
  has_one :person
  has_and_belongs_to_many :roles

  validates :username, presence: true
end
