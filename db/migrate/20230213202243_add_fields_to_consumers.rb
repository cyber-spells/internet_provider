class AddFieldsToConsumers < ActiveRecord::Migration[6.1]
  def change
    add_column :consumers, :full_name, :string
    add_column :consumers, :phone, :string
    add_column :consumers, :address, :string
    add_column :consumers, :longitude, :float
    add_column :consumers, :latitude, :float
    add_column :consumers, :tariff_id, :integer, null: false
    add_column :consumers, :balance, :float, default: 0, null: false
    add_column :consumers, :tariff_expiration_at, :date
  end
end
