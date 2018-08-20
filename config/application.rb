require_relative 'boot'
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder' # add for ransack
require 'rails/all'

# FIXME: from roo
# require 'csv'
require 'iconv'
require 'roo'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BabyName
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.time_zone = 'Beijing'

    # 加载/lib下的所有库
    config.autoload_paths += %W(#{config.root}/lib)
    config.eager_load_paths += %W(#{config.root}/lib)

    # Ensure App config files exist.
    if Rails.env.development?
      %w(redis secrets elasticsearch database cable social_login).each do |fname|
        filename = "config/#{fname}.yml"
        next if File.exist?(Rails.root.join(filename))
        FileUtils.cp(Rails.root.join("#{filename}.sample"), Rails.root.join(filename))
      end
    end

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'
    config.i18n.available_locales = ['zh-CN', 'zh-cn', 'en', 'zh-TW']

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.i18n.fallbacks = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end

  # def test_iso_8859_1
  #   file = File.open(File.join(TESTDIR, "iso_8859_1.csv"))
  #   expected_result = 42 # TODO: replace with actual result
  #   options = { csv_options: { encoding: Encoding::ISO_8859_1 } }
  #   workbook = Roo::CSV.new(file.path, options)
  #   result = workbook.last_column
  #   assert_equal expected_result, result
  # end
end
