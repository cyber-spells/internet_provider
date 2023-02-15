class ChangePriceInTariffs < ActiveRecord::Migration[6.1]
  def change
    change_column :tariffs, :price, :float
  end
end
