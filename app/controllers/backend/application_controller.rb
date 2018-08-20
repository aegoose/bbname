# -*- encoding : utf-8 -*-
module Backend
  class ApplicationController < ::ApplicationController
    before_action :authenticate_admin!
    before_action :set_super_cookies
    
    layout 'admin_application'
    add_breadcrumb I18n.t('navs.backend.home'), :backend_root_path

    # include Rails.application.routes.url_helpers
    # delegate :default_url_options, :url_options, to: :@context

    # protect_from_forgery prepend: true
    # protect_from_forgery with: :exception
    # include PingyinParseable
    # include CustomRescueErrors

    def respond_modal_with(*args, &blk)
      options = args.extract_options!
      options[:responder] = ModalResponder
      respond_with *args, options, &blk
    end

    # include Pundit
    # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # def pundit_user
    #   current_admin
    # end

    # private
    # # def user_not_authorized
    # #   flash[:alert] = "You are not authorized to perform this action."
    # #   redirect_to(request.referrer || root_path)
    # # end
    # def user_not_authorized(exception = nil)
    #   policy_name = exception.policy.class.to_s.underscore
    #   flash[:show_not_authorized] = '对不起，你无权限访问。 请联系管理员解决， 谢谢'
    #   logger.info "---------------========#{policy_name}.#{exception.query}"
    #   if session['user_referer_url'] && request.fullpath != session['user_referer_url']
    #     redirect_to session['user_referer_url']
    #   else
    #     redirect_to root_path
    #   end
    # end
    include AuthorizeAccessable

    private
    def set_super_cookies
      adm = current_admin
      c_role = cookies[:role]
      if adm.super? && c_role
        adm.org_role = adm.role
        adm.role = c_role.to_sym
      end
    end

    # def custom_error_log
    #   @custom_error_logger ||= Logger.new("#{Rails.root}/log/#{Rails.env}-errors.log")
    #   @custom_error_logger.level = Logger::WARN unless Rails.env.development?
    #   @custom_error_logger
    # end
    #
    # def custom_log(e, status, code)
    #   msg = e.try(:message)
    #   bt =  e&.backtrace || []

    #   lines = bt[0]&.gsub(/([^\:]+\:\d+\:).*/, '\1')

    #   custom_error_log.error "====Exception(#{e.class}):#{lines} message:#{msg}, status: #{status}, code: #{code}, params: #{params.to_unsafe_h.except('password', 'password_confirmation')}"
    #   custom_error_log.info(bt&.join("\n")) unless bt.blank?
    # end

  end
end
