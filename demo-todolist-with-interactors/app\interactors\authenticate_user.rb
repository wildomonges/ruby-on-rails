# frozen_string_literal: true

# AuthenticateUser interactor
class AuthenticateUser
  include Interactor

  def call
    user = User.set_current_user(context.user_id)
    if user
      context.user = user
    else
      context.fail!(message: I18n.t('authenticate_user.failure'))
    end
  end
end
