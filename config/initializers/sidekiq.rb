# see redis.rb
# $cfg = Rails.application.secrets[:redis]
# url = "redis://#{$cfg[:host]}:#{$cfg[:port]}/#{$cfg[:db_sidekiq]}"
# Sidekiq.configure_server do |config|
#   config.redis = { :url => url , :namespace => "#{$cfg[:ns_sidekiq]}" }
#   # config.options[:job_logger] = Sidekiq::MyJobLogger
# end

# Sidekiq.configure_client do |config|
#   config.redis = { :url => "redis://#{$cfg[:host]}:#{$cfg[:port]}/#{$cfg[:db_sidekiq]}", :namespace => "#{$cfg[:ns_sidekiq]}" }
# end


# Sidekiq.configure_server do |config|
#   config.average_scheduled_poll_interval = 5 # default is 15
#   Change the connection pool to 30 for production usage
#   sconfig = Rails.application.config.database_configuration[Rails.env]
#   sconfig['pool'] = 50
#   ActiveRecord::Base.establish_connection sconfig
#   config.options[:job_logger] = Sidekiq::MyJobLogger
# end

require 'sidekiq/scheduler'
Sidekiq.configure_server do |config|
  config.on(:startup) do

    Sidekiq::Logging.logger.level = Logger::INFO
    if Rails.env.production?
      Sidekiq::Logging.logger.level = ActiveRecord::Base.logger.level
    end
    ActiveRecord::Base.logger = Sidekiq::Logging.logger

    scfg = Rails.application.config_for(:sidekiq_scheduler)
    Sidekiq.schedule = scfg
    # Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq_scheduler.yml', __FILE__))
    Sidekiq::Scheduler.reload_schedule!
  end
end


# require "sidekiq/my_job_logger"

# Sidekiq.configure_server do |config|
# config.options[:job_logger] = Sidekiq::MyJobLogger
# end
# Sidekiq 5+ disabled by default
Sidekiq::Extensions.enable_delay!
