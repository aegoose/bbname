# source 'https://gems.ruby-china.org'
source 'https://rubygems.org/'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
gem 'turbolinks', '~> 5.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :assets do
  gem 'turbo-sprockets-rails3'        # speedup assets
  # gem 'sprockets', '~> 3.0'
end

gem 'bootstrap-sass', '~> 3.3.6'        # bootstrap framework
gem 'font-awesome-rails'                # popular svg icons
gem 'ionicons-rails'                    # svg icon
gem 'kaminari'                          # pager
gem 'awesome_nested_set'                # model self referrence
gem 'adminlte2-rails', git:'https://github.com/aegoose/adminlte2-rails'

gem 'multi_logger'                      # multi type of logger
gem 'lograge'                           # log to one line
gem 'settingslogic'                     # read setting with yml

gem 'jquery-rails'
# gem 'rails-assets-jquery', source: 'https://rails-assets.org'
# gem 'rails-assets-jquery-ujs', source: 'https://rails-assets.org'
gem 'momentjs-rails', '~> 2.17'             # momentjs framework
# gem 'rails-assets-momentjs', source: 'https://rails-assets.org'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
# gem 'rails-assets-bootstrap3-datetimepicker', source: 'https://rails-assets.org'
gem 'chosen-rails'  # select widget
# gem 'rails-assets-chosen', source: 'https://rails-assets.org'
# gem 'onmount_rails', '~> 1.3'
gem 'rails-assets-onmount', source: 'https://rails-assets.org'
gem 'select2-rails'
# gem 'rails-assets-select2', source: 'https://rails-assets.org'
# gem 'rails-assets-select2-bootstrap', source: 'https://rails-assets.org'
gem 'rails-assets-bootstrap-validator', source: 'https://rails-assets.org'
# gem 'bootstrap-datepicker-rails'
gem 'bootstrap-datepicker-rails', :require => 'bootstrap-datepicker-rails', :git => 'https://github.com/Nerian/bootstrap-datepicker-rails'
# gem 'rails-assets-bootstrap-datepicker', source: 'https://rails-assets.org'
# gem 'rails-assets-bootstrap-datepicker-mobile', source: 'https://rails-assets.org'

gem 'twitter-bootstrap-rails-confirm'       # dialog
gem 'simple-navigation'                     # menu and breadcrumbs
gem 'simple_navigation_bootstrap'           # simple-navigation for bootstrap
gem 'simple_form'                           # popular form widget
gem 'breadcrumbs_on_rails'                  # custom breadcrumb
gem 'tabs_on_rails'                         # tab and menu

# http://www.jacklmoore.com/autosize/
# gem 'autosize', '~> 2.4'                  # autosize for textarea
gem 'rails-assets-autosize', source: 'https://rails-assets.org'
# gem 'jquery-slimscroll-rails'           # need jquery-ui
gem 'slim_scroll'
gem 'bootstrap-wysihtml5-rails'
gem 'zeroclipboard-rails'
gem 'carrierwave', '~> 1.0'             # file upload tool
gem 'mini_magick'                       # imagemagick tool
gem 'mime-types'
# gem 'rails-assets-jquery-file-upload', source: 'https://rails-assets.org'
gem 'jquery-fileupload-rails'

gem 'uuidtools'
gem 'whenever', :require => false       # for crontab job
gem 'enumerize'                         # enum with rails
gem 'time_difference'                   # calc time between
gem 'seed-fu', '~> 2.3'                 # db_seed with files
gem 'chinese_pinyin'
gem 'ransack' #

gem 'bootbox-rails', '~> 0.5.0'        # bootstrap dialog, last update is 2015
gem 'slim-rails'                        # vs haml-rails
gem 'simple_captcha2', require: 'simple_captcha'
gem 'devise'                            # login framework
gem 'pundit'                            # just like cancancan

gem 'browser'
gem 'rest-client'

# gem 'rubyzip', '~> 1.1.0'
# gem 'axlsx', '2.1.0.pre'
# gem 'axlsx_rails'
# gem 'axlsx' # , '~> 2.0', '>= 2.0.1' # , https://github.com/randym/axlsx
gem 'rubyzip', '>= 1.2.1'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'
# gem 'ekuseru' # to xlsx
# gem 'spreadsheet' # read xls
gem 'roo' # , git:'https://github.com/roo-rb/roo'
gem 'roo-xls'
gem 'iconv'

# IE
# gem 'html5shiv-js-rails'
# gem 'respond-js-rails'


gem 'underscore-rails'                 # support '_.'
# # gem 'redis-rails'
gem 'dalli' # https://github.com/petergoldstein/dalli # memcached
gem 'second_level_cache', '~> 2.3.0'
gem 'redis'
gem 'hiredis'
gem 'redis-namespace'
gem 'redis-objects'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'sidekiq-scheduler' #
# # gem 'sidekiq-cron', '~> 0.6.3' #
# # gem 'sinatra', require: false
# # gem 'capistrano-sidekiq', group: :development
# performance
# # gem 'newrelic_rpm'
# gem 'elasticsearch-model'
# gem 'elasticsearch-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'selenium-webdriver'

  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  # gem 'pry-nav'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  # gem 'erb2slim'
  gem 'erb_to_slim'
  # gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'html2slim'
  gem 'haml2slim'
  gem 'annotate'

  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails'
  gem 'capistrano-rails-console', require: false
  # gem 'rvm-capistrano'        # skip this gem
  # gem 'capistrano-rvm'
  # gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano3-puma'
  # gem 'capistrano-sidekiq'
  gem 'capistrano-sidekiq', '~> 1.0'
  gem 'better_errors'
  # gem 'solargraph'
  # gem 'rubocop'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
