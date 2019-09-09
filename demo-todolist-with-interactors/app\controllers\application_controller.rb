# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    User.current_user
  end

  private

  def authenticate_user!
    AuthenticateUser.call(user_id: session[:user_id])
  end

  def user_not_authorized
    message = I18n.t('user.not_authorized')
    if request.xhr?
      flash.now[:alert] = message
      render 'admin/messages/refresh'
    else
      flash[:alert] = message
      redirect_to(request.referrer || root_path)
    end
  end
end
