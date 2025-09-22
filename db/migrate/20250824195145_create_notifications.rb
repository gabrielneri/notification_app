class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.integer :channel, null: false
      t.integer :status, default: 0
      t.string :recipient, null: false
      t.string :subject, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
