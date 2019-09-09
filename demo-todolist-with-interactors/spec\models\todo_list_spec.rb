# frozen_string_literal: true

require 'rails_helper'

Rspec.describe TodoList, type: :model do
  it 'has a valid factory' do
    expect(build(:todo_list)).to be_valid
  end

  describe 'Asociations' do
    it { should have_many :todo_items }
    it { should belong_to :user }
  end

  describe 'Validation - ' do
    context 'required attributes - ' do
      it { should validate_presence_of :user }
      it { should validate_presence_of :title }
    end

    context ' todo_list is not valid -' do
      let(:todo_list) { build(:todo_list) }

      it ' without user' do
        todo_list.user = nil
        expect(todo_list).to_not be_valid
      end

      it 'without title' do
        todo_list.title = nil
        expect(todo_list).to_not be_valid
      end
    end
  end

  describe 'scopes' do
    it 'return available_todo_items' do
      # default todo_list status done: false
      todo_list = create(:todo_list)
      todo_item = create(:todo_item, todo_list: todo_list)

      expect(todo_list.todo_items.first).to eq(todo_item)
    end
  end
end
