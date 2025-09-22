# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  channel    :integer          not null
#  recipient  :string           not null
#  status     :integer          default("pending")
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Notification < ApplicationRecord
  enum :channel, { email: 0 }
  enum :status, { pending: 0, processing: 1, sent: 2, failed: 3 }

  validates :recipient, :subject, :body, presence: true
end
