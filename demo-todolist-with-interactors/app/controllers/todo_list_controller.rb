# frozen_string_literal: true

# TodoList controller
class TodoListsController < ApplicationController
  before_action :retrieve_todo_list, only: %i[show]

  def index
    @lists = policy_scope(TodoList).order("#{sort_by} #{sort_order}")
  end

  def show
    authorize @list
  end

  # Mark an item as done and return user back from whence they came!
  def complete_item
    authorize TodoList
    CompleteTodoItem.call(id: params[:id])
    flas[:notice] = I18n.t('messages.success')
    redirect_to :back
  end

  def new
    @list = TodoList.new
  end

  def create
    result = CreateTodoList.call(params: todo_list_params, user: User.current_user)
    if result.success?
      @list = result.todo_list
      redirect_to todo_lists_url
    else
      flash[:error] = I18n.t('models.todo_list.error_on_save')
      redirect_to new_todo_list_url
    end
  end

  private

  def sort_by
    params[:sort] || 'created_at'
  end

  def sort_order
    params[:asc] == 'false' ? 'ASC' : 'DESC'
  end

  def retrieve_todo_list
    @list = TodoList.find_by(id: params[:id])
  end

  def todo_list_params
    params.require(:todo_list).permit(:title)
  end
end
