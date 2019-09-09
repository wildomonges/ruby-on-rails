class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name, limit: 50

      t.timestamps
    end
  end
end
