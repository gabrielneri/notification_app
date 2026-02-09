return if Rails.env.test?

Shoryuken.configure_client do |config|
  config.sqs_client = Aws::SQS::Client.new(
    region: ENV.fetch('AWS_REGION'),
    access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    endpoint: ENV.fetch('AWS_SQS_ENDPOINT'),
    verify_checksums: false
  )
end

Shoryuken.configure_server do |config|
  config.sqs_client = Aws::SQS::Client.new(
    region: ENV.fetch('AWS_REGION'),
    access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    endpoint: ENV.fetch('AWS_SQS_ENDPOINT'),
    verify_checksums: false
  )
end
