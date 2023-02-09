class CreateSolveds < ActiveRecord::Migration[6.1]
  def change
    create_table :solveds do |t|
      t.text :text, null: false
      t.integer :complaint_id, null: false
      t.integer :employee_id, null: false

      t.timestamps
    end
  end
end
