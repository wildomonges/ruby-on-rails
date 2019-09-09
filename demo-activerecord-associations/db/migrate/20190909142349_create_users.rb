class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.belongs_to :country, foreign_key: true
      t.string :username, limit: 20

      t.timestamps
    end
  end
end
