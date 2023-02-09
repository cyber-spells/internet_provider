class CreateComplaints < ActiveRecord::Migration[6.1]
  def change
    create_table :complaints do |t|
      t.integer :employee_id
      t.integer :consumer_id
      t.text :text, null: false
      t.string :user_name
      t.string :phone
      t.string :address
      t.integer :state, default: 0, null:false

      t.timestamps
    end
  end
end
