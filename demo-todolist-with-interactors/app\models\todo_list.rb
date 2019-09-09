# frozen_string_literal: true

class TodoList < ApplicationRecord
  has_many :todo_items, dependent: :destroy
  belongs_to :user

  validates :user, :title, presence: true

  scope :available_todo_items, -> { where(done: false) }

  def formatted_title
    title + (todo_items.empty? ? ' (Complete)' : '')
  end
end
