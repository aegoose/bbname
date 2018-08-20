# config valid only for current version of Capistrano
lock "3.9.1"

set :application, 'bbname'
set :repo_url, 'git@gitlab.com:oocitizen/bbname.git'
set :user, 'deploy'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :use_sudo,        false
# set :pty, true
set :deploy_via,      :remote_cache
set :deploy_to,  "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
append :linked_files, "config/database.yml", "config/secrets.yml", "config/redis.yml", "config/elasticsearch.yml", "config/social_login.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :keep_releases, 2
set :format, :airbrussh
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

set :puma_threads, [0, 2]
set :puma_workers, 1
set :puma_user, fetch(:user)
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock" #accept array for multi-bind
set :puma_control_app, false
set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_preload_app, false
set :puma_daemonize, false
set :puma_plugins, []  #accept array of plugins
set :puma_tag, fetch(:application)
set :puma_restart_command, 'bundle exec puma'
append :rbenv_map_bins, 'puma', 'pumactl'
# set :rbenv_map_bins, fetch(:rbenv_map_bins).to_a.concat(%w(puma pumactl))


# server "#{fetch(:server_ip)}", port: 6789, roles: :root, primary: true, ssh_options: { forward_agent: true, user: "root", keys: %w(~/.ssh/id_rsa.pub) }
# set :puma_nginx, :root
# 以下设置role没有生
set :nginx_home, "/etc/nginx"
set :nginx_config_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :nginx_flags, 'fail_timeout=0'
set :nginx_http_flags, fetch(:nginx_flags)
set :nginx_server_name, "#{fetch(:server_ip)}"
set :nginx_sites_available_path, "#{fetch(:nginx_home)}/sites-available"
set :nginx_sites_enabled_path, "#{fetch(:nginx_home)}/sites-enabled"
set :nginx_socket_flags, fetch(:nginx_flags)
set :nginx_use_ssl, false
set :nginx_ssl_certificate, "#{fetch(:nginx_home)}/ssl/#{fetch(:nginx_config_name)}.crt"
set :nginx_ssl_certificate_key, "#{fetch(:nginx_home)}/ssl/#{fetch(:nginx_config_name)}.key"

set :sidekiq_default_hooks => true
set :sidekiq_pid => File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid') # ensure this path exists in production before deploying.
set :sidekiq_env => fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
set :sidekiq_log => File.join(shared_path, 'log', 'sidekiq.log')
set :sidekiq_options => nil
set :sidekiq_require => nil
set :sidekiq_tag => nil
# set :sidekiq_config => nil # if you have a config/sidekiq.yml, do not forget to set this.
# set :sidekiq_queue => nil
set :sidekiq_timeout => 10
set :sidekiq_role => :app
set :sidekiq_processes => 2
set :sidekiq_options_per_process => nil
# set :sidekiq_options_per_process, ["--queue critical --concurrency 8", "--queue partners --queue exports --concurrency 8", "--queue high --queue searchkick --concurrency 8", "--queue default --queue mailer --concurrency 8"]
# set :sidekiq_options_per_process, ["--queue high", "--queue default --queue low"]
# set :sidekiq_concurrency => nil
# set :sidekiq_use_signals => false
# set :sidekiq_cmd => "#{fetch(:bundle_cmd, "bundle")} exec sidekiq" # Only for capistrano2.5
# set :sidekiqctl_cmd => "#{fetch(:bundle_cmd, "bundle")} exec sidekiqctl" # Only for capistrano2.5
set :sidekiq_user, -> { fetch(:deploy_user) } #user to run sidekiq as
append :rbenv_map_bins, 'sidekiq', 'sidekiqctl'
# set :rbenv_map_bins, fetch(:rbenv_map_bins).to_a.concat(%w(sidekiq sidekiqctl))

#
# bundle exec rails generate capistrano:sidekiq:monit:template
# set :sidekiq_monit_templates_path => 'config/deploy/templates'
# set :sidekiq_monit_conf_dir => '/etc/monit/conf.d'
# set :sidekiq_monit_use_sudo => true
# set :monit_bin => '/usr/bin/monit'
# set :sidekiq_monit_default_hooks => true
# set :sidekiq_monit_group => nil
# set :sidekiq_service_name => "sidekiq_#{fetch(:application)}_#{fetch(:sidekiq_env)}" + (index ? "_#{index}" : '')
# set :sidekiq_monit_use_sudo, true

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }
