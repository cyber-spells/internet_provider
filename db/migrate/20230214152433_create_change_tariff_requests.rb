class CreateChangeTariffRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :change_tariff_requests do |t|
      t.integer :consumer_id
      t.integer :tariff_id
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
