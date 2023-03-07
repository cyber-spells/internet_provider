class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.string :title
      t.integer :consumer_id
      t.float :sum
      t.integer :tariff_id

      t.timestamps
    end
  end
end
