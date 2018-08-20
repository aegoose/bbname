module Backend
  module Accounts
    class SessionsController < Devise::SessionsController
      layout "admin_login"
      include Captcha::Helper
      include WxAccessable

      # skip_before_filter :require_no_authentication, :only => [:create]
      skip_before_action :require_no_authentication, :only => [:create]

      if !Rails.env.test?
        # prepend_before_action :validate_frozen, :validate_captcha, :only => [:create]
        prepend_before_action :validate_captcha, :only => [:create]
      end

      # before_action :configure_sign_in_params, only: [:create]

      # GET /resource/sign_in
      def new
        # 查测到是微信登录，则跳过登录，
        return if before_login_by_wx_pub # TODO:还要考虑强制非微信登录的情况
        # super
        # session[:user_return_to] = request.referer unless request.referer && (request.referer.include?("/sign_in"))
        self.resource = resource_class.new(sign_in_params)
        clean_up_passwords(resource)
      end

      # POST /resource/sign_in
      def create
        super
        bind_wx_pub_after_sign_in(resource)
        clear_captcha_require(sign_in_params[:login])
      end

      # DELETE /resource/sign_out
      def destroy
        adm = current_admin
        super
        unbind_wx_pub_after_sign_out(adm)
      end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_in_params
      #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
      # end
      protected
      def validate_captcha
        if captcha_require?(:login) && !simple_captcha_valid?
          self.resource = resource_class.new(sign_in_params)
          clean_up_passwords(resource)
          flash.now[:danger] = "验证码错误！"
          respond_with_navigational(resource) { render :new }
        end
      end

      def validate_frozen
        # binding.pry
        admin = Admin.find_for_authentication(sign_in_params)
        if admin && admin.is_frozen
          self.resource = resource_class.new(sign_in_params)
          clean_up_passwords(resource)
          flash.now[:danger] = "帐号已被冻结，请联系管理员！"
          respond_with_navigational(resource) { render :new }
        end
      end
    end
  end
end
