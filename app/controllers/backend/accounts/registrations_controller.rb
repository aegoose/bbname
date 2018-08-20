module Backend
  module Accounts
    class RegistrationsController < Devise::RegistrationsController

      layout :dispatch_layout

      prepend_before_action :authenticate_scope!, only: [:edit, :profile, :update, :destroy]

      add_breadcrumb I18n.t('navs.profile.index'), :edit_admin_profile_path, only: [:profile, :edit_password, :edit]

      include AuthorizeAccessable

      # before_action :configure_sign_up_params, only: [:create]
      # before_action :configure_account_update_params, only: [:update]

      # GET /resource/sign_up
      # def new
      #   super
      # end

      # POST /resource
      # def create
      #   super
      # end

      # GET /resource/edit
      def edit
        add_breadcrumb I18n.t('navs.profile.edit')
        super
      end

      # GET /resource/profile
      def profile
        render :profile
      end

      # PUT /resource
      def update
        super
      end

      # GET /resource/profile
      def switch_role
        if current_admin.super? && params[:role]
          cookies[:role] = params[:role]
        end
        # respond_to :json
        redirect_to backend_root_path
      end

      def become
        return unless current_admin.super?
        sign_in(:admin, Admin.find(params[:uid]))
        redirect_to backend_root_path # or user_root_url
      end

      # GET /resource/edit_password 暂时无用
      def edit_password
        add_breadcrumb I18n.t('navs.backend.profile.password')
        super.edit
      end

      # PUT /update_resource_password
      def update_password
        @only_pwd = true
        update
      end

      # DELETE /resource
      # def destroy
      #   super
      # end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      # def cancel
      #   super
      # end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_up_params
      #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
      # end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_account_update_params
      # added_attrs = [:username, :email, :name, :current_password, :password, :password_confirmation, :phone, :qq, :tel, :fax, :desc]
      # devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
      # end

      # The path used after sign up.
      def after_sign_up_path_for(resource)
        super(resource)
      end

      # The path used after sign up for inactive accounts.
      # def after_inactive_sign_up_path_for(resource)
      #   super(resource)
      # end
      def after_update_path_for(resource)
        edit_registration_path(resource)
      end

      def update_resource(resource, params)
        if @only_pwd
          resource.update_with_password(params)
        else
          resource.update_without_password(params)
        end
      end

      private
      def dispatch_layout
        case self.action_name.to_sym
        when :edit, :profile, :update, :update_password
          'admin_application'
        else
          'admin_login'
        end
      end
    end
  end
end
