# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? 'admin'
      can :manage, :all
    elsif user.role? 'buyer'
      can :create, Order
      can :read, Order do |order|
        order.try(:user) == user
      end
      can :create, OrderDetail
      can :read, OrderDetail do |detail|
        detail.order && detail.order.try(:user) == user
      end
      can :create, User
      can :read, User do |u|
        u == user
      end
      can :update, User do |u|
        u == user
      end
    end
  end
end
