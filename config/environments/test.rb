Rails.application.configure do
  # Code is not reloaded between tests
  config.enable_reloading = false

  config.eager_load = false

  # Show limited error reports
  config.consider_all_requests_local = false

  # Disable caching
  config.cache_store = :null_store

  # Mailer
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = false
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Logs
  config.log_level = :warn
  config.logger = Logger.new($stdout)

  config.active_support.deprecation = :stderr
  config.active_record.verbose_query_logs = false

  # Use the test adapter for Active Job
  config.active_job.queue_adapter = :test

  # Avoid touching external services
  # WebMock.disable_net_connect!(allow_localhost: true) if defined?(WebMock)
end
