class CreateConsumers < ActiveRecord::Migration[6.1]
  def change
    create_table :consumers do |t|
      t.string :address
      t.string :phone
      t.string :user_name
      t.integer :tariff_id, null: false
      t.integer :balance, default: 0, null: false
      t.date :tariff_expiration_at
      
      t.timestamps
    end
  end
end
