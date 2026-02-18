return if Rails.env.test?

def sqs_client_options
  options = {
    region: ENV.fetch('AWS_REGION'),
    verify_checksums: false
  }

  if Rails.env.development?
    options[:access_key_id] = ENV.fetch('AWS_ACCESS_KEY_ID')
    options[:secret_access_key] = ENV.fetch('AWS_SECRET_ACCESS_KEY')
    options[:endpoint] = ENV.fetch('AWS_SQS_ENDPOINT')
  end

  options
end

Shoryuken.configure_client do |config|
  config.sqs_client = Aws::SQS::Client.new(**sqs_client_options)
end

Shoryuken.configure_server do |config|
  config.sqs_client = Aws::SQS::Client.new(**sqs_client_options)
end
