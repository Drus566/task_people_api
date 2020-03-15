require 'active_support/security_utils'
require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  ActiveSupport::SecurityUtils.secure_compare(user, ENV["SIDEKIQ_ADMIN_USER"]) &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV["SIDEKIQ_ADMIN_PASSWORD"])
end

Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://127.0.0.1:6379' }
end

Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://127.0.0.1:6379' }
end