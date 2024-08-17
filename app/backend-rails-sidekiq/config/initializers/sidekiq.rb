redis_url = ENV.fetch("JOB_QUEUE_URL").to_s
if redis_url.to_s == ""
  raise StandardError.new("env JOB_QUEUE_URL is invalid. Please check environments")
end

# configure_server
# dequeueする側
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

# configure_client
# enqueueする側
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
