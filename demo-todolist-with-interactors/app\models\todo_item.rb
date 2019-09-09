class TodoItem < ApplicationRecord
  belongs_to :todo_list

  validates :title, presence: true

  # Completes to do item, saving to database.
  def complete!
    update!(done: true)
  end
end