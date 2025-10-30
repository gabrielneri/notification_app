module Channels
  class SmsService < ApplicationService
    def call
      mark_as_processing
      simulate_sms_delivery
      mark_as_sent
    rescue StandardError => e
      mark_as_failed
      Rails.logger.error "[SmsService] Sms delivery failed: #{e.message}"
      raise
    end

    private

    def simulate_sms_delivery
      # simulate API latency
      sleep(0.5)

      # random simulated failure
      return unless rand(20) < 2

      Rails.logger.error "[SmsService] Simulated API failure for notification ##{notification.id}."
      raise StandardError, 'SMS provider API error.'
    end
  end
end
