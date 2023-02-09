class CreateTariffs < ActiveRecord::Migration[6.1]
  def change
    create_table :tariffs do |t|
      t.string :name
      t.integer :speed, default: 0, null: false
      t.integer :price, default: 0, null: false
      t.integer :expiration_days, default: 28, null: false

      t.timestamps
    end
  end
end
