class AddFieldsToChangeTariffRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :change_tariff_requests, :state, :integer, default: 0
    add_column :change_tariff_requests, :comment, :string, default: ''
  end
end
