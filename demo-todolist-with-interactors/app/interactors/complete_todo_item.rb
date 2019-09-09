# frozen_string_literal: true

# CompleteTodoItem interactor
class CompleteTodoItem
  include Interactor

  def call
    todo_item = TodoItem.find_by(id: context.id)

    if todo_item
      todo_item.complete!
    else
      context.fail!(message: I18n.t('authenticate_user.failure'))
    end
  end
end
