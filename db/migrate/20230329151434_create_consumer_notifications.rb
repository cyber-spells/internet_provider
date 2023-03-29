class CreateConsumerNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :consumer_notifications do |t|
      t.string :title
      t.string :body
      t.integer :consumer_id
      t.boolean :viewed?, default: false

      t.timestamps
    end
  end
end
