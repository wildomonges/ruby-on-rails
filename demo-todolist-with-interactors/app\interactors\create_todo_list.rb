# frozen_string_literal: true

# CreateTodoList interactor
class CreateTodoList
  include Interactor

  def call
    todo_list = TodoList.new(context.params)
    todo_list.user = context.user
    if todo_list.save
      context.todo_list = todo_list
    else
      context.fail!(message: I18n.t('authenticate_user.failure'))
    end
  end
end
