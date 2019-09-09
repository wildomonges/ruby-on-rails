# frozen_string_literal: true

# User class
class User < ApplicationRecord
  extend Enumerize

  # Default it does a soft delete updating deleted_at column
  acts_as_paranoid

  enumerize :user_type,
            in: %i[superadmin business_owner business_collaborator],
            default: :business_owner,
            predicates: true
  enumerize :business_type, in: %i[person company], default: :person, predicates: true
  enumerize :status, in: %i[active inactive], default: :active, predicates: true

  has_many :customers, dependent: :destroy
  has_many :collaborators, class_name: 'User', foreign_key: 'parent_id', dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :diary_books, dependent: :destroy
  has_many :ledgers, dependent: :destroy
  has_many :balance_suma_saldos, dependent: :destroy
  has_many :balance_generals, dependent: :destroy

  belongs_to :parent, class_name: 'User', optional: true
  belongs_to :plan, optional: true

  devise  :database_authenticatable, :trackable,
          :registerable, :recoverable, :rememberable,
          authentication_keys: [:username]

  validates :password, :password_confirmation, presence: true, on: %i[create update]
  validates :username, presence: true
  validates_confirmation_of :password
  validates :email,
            :business_name,
            :ruc,
            :activity,
            :plan,
            presence: true,
            if: -> { business_owner? }

  validates_uniqueness_of :username, on: %i[create update]
  validates_length_of :password, in: Devise.password_length, if: ->(user) { user.password.present? }
  validates_length_of :password_confirmation, in: Devise.password_length, if: ->(user) { user.password_confirmation.present? }

  scope :active_collaborators, -> { where(status: :active, user_type: :business_collaborator) }

  after_create :set_expiration_date

  def activate!
    raise 'User status was not updated' unless update_column(:status, User.status.active)
    raise 'Collaborators status were not updated' unless collaborators.update_all(status: User.status.active)
  end

  def deactivate!
    raise 'User status was not updated' unless update_column(:status, User.status.inactive)
    raise 'Collaborators status were not updated' unless collaborators.update_all(status: User.status.inactive)
  end

  def active_for_authentication?
    super && status.active?
  end

  def inactive_message
    I18n.t('auth.disabled_account')
  end

  def my_collaborator?(user_id)
    collaborator = User.where(id: user_id, parent_id: id).first
    collaborator.present? && business_owner?
  end

  def can_edit?(user_id)
    id.to_s == user_id.to_s || my_collaborator?(user_id)
  end

  def can_update?(user_id)
    can_edit?(user_id)
  end

  def can_show?(user_id)
    can_edit?(user_id)
  end

  def can_new?
    user_type.business_owner?
  end

  def can_create?
    can_new?
  end

  private

  def owner
    business_owner? ? self : parent
  end

  def allow_create_customer?
    owner.customers.active.size < owner.plan.max_customers
  end

  def allow_create_collaborator?
    owner.collaborators.active_collaborators.size < owner.plan.max_collaborators
  end
end
