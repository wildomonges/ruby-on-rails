class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.belongs_to :user, foreign_key: true
      t.string :first_name, limit: 20
      t.string :last_name, limit: 20
      t.string :type

      t.timestamps
    end
  end
end
