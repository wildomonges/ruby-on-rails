# frozen_string_literal: true

class UsersController < ApplicationController
  # CSRT: prevent Cross-Site Request Forgery
  protect_from_forgery

  respond_to :html, :js, :json

  before_action :authenticate_user!, except: %i[update_password user_params]
  before_action :check_permissions, :reset_current_money
  skip_before_filter :require_no_authentication

  def check_permissions
    if !current_user.is_admin? && params[:action] == 'index' && params[:controller] == 'users'
      flash[:danger] = 'No estas autorizado'
      redirect_to dashboard_index_path
    elsif !current_user.is_admin? && params[:action] == 'subscribers' && params[:controller] == 'users'
      flash[:danger] = 'No estas autorizado'
      redirect_to dashboard_index_path
    end
  end

  def index
    @users = User.where.not(username: user_no_registered).order(username: :asc)
  end

  def subscribers
    @subscribers = Subscriber.all.order(created_at: :desc)
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_password_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, bypass: true
      current_user = @user
      flash[:success] = 'Se ha cambiado su clave de accesso'
    else
      flash[:danger] = 'No se pudo cambiar su clave de accesso, vuelva a intentarlo'
    end

    redirect_to session[:previous_url]
  end

  def update_user
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, bypass: true
      current_user = @user
      flash[:success] = 'Se ha actualizado su información'
    else
      flash[:danger] = 'No se ha podido actualizar su información'
    end

    redirect_to session[:previous_url]
  end

  def user_password_params
    params.required(:user).permit(:password, :password_confirmation)
  end

  def user_params
    params.required(:user).permit(:username, :email, :ruc)
  end
end
