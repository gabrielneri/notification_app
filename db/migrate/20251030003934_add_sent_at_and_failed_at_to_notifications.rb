class AddSentAtAndFailedAtToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :sent_at, :datetime
    add_column :notifications, :failed_at, :datetime
  end
end
