module Backend
  module Accounts
    class PasswordsController < Devise::PasswordsController
      layout :dispatch_layout

      # GET /resource/password/new
      # def new
      #   super
      # end

      # POST /resource/password
      # def create
      #   super
      # end

      # GET /resource/password/edit?reset_password_token=abcdef
      # def edit
      #   super
      # end

      # PUT /resource/password
      # def update
      #   super
      # end

      # protected

      # def after_resetting_password_path_for(resource)
      #   super(resource)
      # end

      # The path used after sending reset password instructions
      # def after_sending_reset_password_instructions_path_for(resource_name)
      #   super(resource_name)
      # end

      private
      def dispatch_layout
        case self.action_name.to_sym
        when :edit, :update
          'admin_application'
        else
          'admin_login'
        end
      end

    end
  end
end
