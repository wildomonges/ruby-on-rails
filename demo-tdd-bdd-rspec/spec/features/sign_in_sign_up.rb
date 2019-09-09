# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home page', type: :feature do
  scenario 'Sign up' do
    user = build(:user_owner)
    visit home_index_pathrspe
    fill_in 'Razón social', with: user.business_name
    fill_in 'RUC/CI', with: user.ruc
    fill_in 'Rubro/Actividad', with: user.activity
    fill_in 'Nombre de Usuario', with: user.username
    fill_in 'Email', with: user.email
    fill_in 'Contraseña', with: user.password
    fill_in 'Repita Contraseña', with: user.password_confirmation
    click_button 'Registrarse'
    sleep(5)
    expect(page).to have_text('Inicio')
  end

  scenario 'Sign in' do
    user = create(:user_owner)
    visit home_index_path
    sleep(5)
    click_link 'Login'
    sleep(5)
    fill_in 'Nombre de Usuario', with: user.username
    fill_in 'Contraseña', with: user.password
    click_button 'Iniciar Sesión'
    sleep(5)
    expect(page).to have_text('Inicio')
  end
end
