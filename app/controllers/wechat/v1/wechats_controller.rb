module Wechat
  module V1
    class WechatsController < Devise::SessionsController
      layout "admin_login"
      layout :dispatch_layout

      respond_to :html, :json
      # before_action :set_area, only: [:show, :edit, :update, :destroy]
      include WxAccessable

      # GET /wechat/v1/sign_in
      def new
        return if after_login_by_wx_pub
        super
      end

      # GET /wechat/v1/sign_up
      def create
        # logger.debug "--#{controller_path}#new"
        # FIXME: no-use
        auth_opts = { scope: resource_name, recall: "#{controller_path}#sign_in" }
        self.resource = warden.authenticate!(auth_opts)
        set_flash_message!(:notice, :signed_in)
        wx_pub_sign_in_and_redirect_to_current_path(resource)
        # sign_in(resource_name, resource)
        # bind_wx_pub_after_sign_in(resource)
        # respond_with resource, location: after_sign_in_path_for(resource)
        # super do
        #   bind_wx_pub_after_sign_in(resource)
        # end
      end

      private
      def dispatch_layout
        # case self.action_name.to_sym
        # when :edit, :profile, :update, :update_password
        #   'admin_application'
        # else
        #   'admin_login'
        # end
        'admin_login'
      end

      def after_sign_out_path_for(resource_or_scope)
        # new_session_path(resource_or_scope)
        if resource_or_scope == :user
          root_path
        elsif resource_or_scope == :admin
          # new_admin_session_path
          # backend_root_path
          request.env['omniauth.origin'] || stored_location_for(resource) || backend_root_path
        end
      end

    end
  end
end
