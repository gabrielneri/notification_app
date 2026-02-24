Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance.
  config.eager_load = true

  # Disable full error reports.
  config.consider_all_requests_local = false

  # Caching
  config.cache_store = :memory_store

  # Storage
  config.active_storage.service = :local

  # Logger
  config.log_level = :info
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::Logger.new(STDOUT)

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Raise delivery errors if the mailer can't send.
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  # Mailer
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address: 'smtp.resend.com',
    port: 465,
    user_name: 'resend',
    password: ENV.fetch('RESEND_API_KEY', nil),
    tls: true
  }

  # URL options
  config.action_mailer.default_url_options = {
    host: ENV.fetch('APP_HOST', nil)
  }

  config.hosts << ENV['APP_HOST'] if ENV['APP_HOST'].present?

  config.hosts << 'localhost'
  config.hosts << '127.0.0.1'
end
