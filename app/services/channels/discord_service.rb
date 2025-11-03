module Channels
  class DiscordService < ApplicationService
    def call
      mark_as_processing
      send_message
      mark_as_sent
    rescue SocketError, Net::OpenTimeout, Net::ReadTimeout => e
      mark_as_failed
      Rails.logger.error "[DiscordService] Network error while sending Discord notification: #{e.message}"
      raise
    rescue StandardError => e
      mark_as_failed
      Rails.logger.error "[DiscordService] Failed to send Discord notification: #{e.message}"
      raise
    end

    private

    def send_message
      uri = URI(notification.recipient)
      payload = { content: "**#{notification.subject}**\n#{notification.body}" }

      response = make_request(uri, payload)

      return if response.is_a?(Net::HTTPSuccess)

      raise StandardError, "Discord API error: #{response.body}"
    end
  end
end
