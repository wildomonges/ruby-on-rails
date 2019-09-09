# frozen_string_literal: true

class User < ActiveRecord::Base
  has_and_belongs_to_many :roles, join_table: :roles_users
  has_many :orders
  has_many :coupons

  validates :username, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, message: 'Email inválido' }
  validates :ruc, presence: true
  validates :password, :password_confirmation, presence: true, on: %I[create update]

  before_create :set_user_roles

  # Include defalt devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def role?(role)
    !!roles.find_by_name(role.to_s)
  end

  private

  # default user role is buyer
  def set_user_roles
    self.role_ids = Role.where(name: 'buyer').first.id if role_ids.blank?
  end
end
