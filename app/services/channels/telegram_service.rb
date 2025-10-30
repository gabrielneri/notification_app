module Channels
  class TelegramService < ApplicationService
    TELEGRAM_API_URL = "https://api.telegram.org/bot#{ENV.fetch('TELEGRAM_BOT_TOKEN')}".freeze

    def call
      mark_as_processing
      send_message
      mark_as_sent
    rescue SocketError, Net::OpenTimeout, Net::ReadTimeout => e
      mark_as_failed
      Rails.logger.error "[TelegramService] Network error while sending Telegram notification: #{e.message}"
      raise
    rescue StandardError => e
      mark_as_failed
      Rails.logger.error "[TelegramService] Failed to send Telegram notification: #{e.message}"
      raise
    end

    private

    def send_message
      uri = URI("#{TELEGRAM_API_URL}/sendMessage")
      payload = {
        chat_id: notification.recipient,
        text: "#{notification.subject}\n#{notification.body}"
      }

      response = make_request(uri, payload)

      return if response.is_a?(Net::HTTPSuccess)

      raise StandardError, "Telegram API error: #{response.body}"
    end

    def make_request(uri, payload)
      req = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
      req.body = payload.to_json

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end
    end
  end
end
