class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :detect_wx_browser

  # include WxAccessable
  include PingyinParseable
  include CustomRescueErrors
  protect_from_forgery with: :exception

  @@errlog = nil
  def custom_error_log
    if @@errlog.blank?
      @@errlog = Logger.new("#{Rails.root}/log/#{Rails.env}-errors.log")
      @@errlog.level = logger.level
    end
    @@errlog
  end

  def custom_log(e, status, code)
    msg = e.try(:message)
    bt =  e&.backtrace || []

    lines = bt[0]&.gsub(/([^\:]+\:\d+\:).*/, '\1')

    custom_error_log.error "====Exception(#{e.class}):#{lines} message:#{msg}, status: #{status}, code: #{code}, params: #{params.to_unsafe_h.except('password', 'password_confirmation')}"
    custom_error_log.info(bt[0..20]&.join("\n")) unless bt.blank?
  end

  protected
  def detect_wx_browser
    request.variant = :wx if browser.wechat? || params[:variant] == 'wx'
    # if force to skip wx, then skip!
  end

  def after_sign_out_path_for(resource_or_scope)
    # new_session_path(resource_or_scope)
    if resource_or_scope == :user
      root_path
    elsif resource_or_scope == :admin
      # new_admin_session_path
      # puts "---------kkkkkkkkk"
      backend_root_path
    end
  end

  def configure_permitted_parameters
    added_attrs = [:username, :email, :name, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    up_attrs = [:username, :email, :name, :current_password, :password, :password_confirmation, :phone, :qq, :tel, :fax, :desc]
    devise_parameter_sanitizer.permit :account_update, keys: up_attrs
  end

  def storable_location?
    # navigable_format? &&
    request.get? && !devise_controller? && !request.xhr? && !['/backend', '/'].include?(request.fullpath)
  end
  def store_user_location!
    # :user is the scope we are authenticating
    logger.debug("---------store_user_location! #{request.fullpath}")
    store_location_for(:admin, request.fullpath)
  end

end
