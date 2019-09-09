# frozen_string_literal: true

class TodoListPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.has_role?(:admin)
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def show?
    user.id == record.id
  end

  def complete_item?
    show?
  end
end
