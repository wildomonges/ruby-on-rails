# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Todo List Show page', type: :feature do
  scenario 'Set as done todo list' do
    todo_item = create(:todo_item)
    visit show_todo_list_item_path(todo_item)
    sleep(5)
    click_button I18n.t('actions.done')
    sleep(5)
    expect(page).to have_text(I18n.t('messages.success'))
  end
end
