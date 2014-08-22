Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'netclerk' }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'netclerk' }
end

