# frozen_string_literal: true

class User < ApplicationRecord
  has_many :todo_lists, dependent: :destroy

  def self.set_current_user(id)
    return if @_current_user.present?

    @_current_user = User.find(id)
  end

  # Avoid a DB query each time we need the currently logged in user
  def self.current_user
    @_current_user
  end
end
