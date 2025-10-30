# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  channel    :integer          not null
#  failed_at  :datetime
#  recipient  :string           not null
#  sent_at    :datetime
#  status     :integer          default("pending")
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Notification < ApplicationRecord
  enum :channel, { email: 0 }
  enum :status, { pending: 0, processing: 1, sent: 2, failed: 3 }

  validates :channel, :recipient, :body, presence: true

  validates :subject, presence: true, if: :email?

  validates :recipient, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: :invalid_email
  }, if: :email?
end
