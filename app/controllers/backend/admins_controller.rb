# frozen_string_literal: true

module Backend
  class AdminsController < Backend::ApplicationController
    respond_to :html, :json
    before_action :set_admin, only: %i[show edit update destroy]
    before_action do |_action|
      authorize Admin
    end
    add_breadcrumb I18n.t("navs.backend.admins"), :backend_admins_path

    # GET /admins
    # GET /admins.json
    def index
      add_breadcrumb I18n.t('navs.backend.admins_index'), :backend_admins_path
      @qr = params.fetch(:query){Hash.new}.permit(:key, :status)
      @qr = @qr.select { |k, v| { k => v } unless v.blank? }

      qrkey = @qr.delete(:key)

      @admins = Admin.by_query(@qr).by_key(qrkey).page(params[:page])
      @qr[:key] = qrkey
    end

    # GET /admins/1
    # GET /admins/1.json
    def show; end

    # GET /admins/new
    def new
      @admin = Admin.new
      @only_pwd = !!params[:pwd]
      respond_modal_with @admin
    end

    # GET /admins/1/edit
    def edit
      @only_pwd = !!params[:pwd]
      respond_modal_with @admin
    end

    # POST /admins
    # POST /admins.json
    def create
      update
      # @admin = Admin.new(admin_params)
    end

    # PATCH/PUT /admins/1
    # PATCH/PUT /admins/1.json
    def update
      pam = admin_params
      if @admin.blank?
        @admin = Admin.new(pam)
        # @admin.skip_reconfirmation!
      else
        @admin.attributes = pam
      end

      unless current_admin&.editable?(@admin)
        @admin.errors.add(:role, :invalid_permission)
        raise ApiUserErrors::AdminUpdateError, @admin.error_messages
      end

      isOk = @admin.save

      raise ApiUserErrors::AdminUpdateError, @admin.error_messages unless isOk

      respond_to do |format|
        format.html {redirect_to backend_admins_url, notice: '保存成功!' }
        format.json { render :update }
      end
    end

    def lock
      @admin.status = :locked
      isOk = @admin.save

      raise ApiUserErrors::AdminUpdateError, @admin.error_messages unless isOk

      respond_to do |format|
        format.html { redirect_to backend_admins_url, notice: '保存成功!' }
        format.json { render :lock }
      end
    end

    # DELETE /admins/1
    # DELETE /admins/1.json
    def destroy
      @admin.destroy
      respond_to do |format|
        format.html { redirect_to backend_admins_url, notice: '删除成功!' }
        format.json { render :destroy }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      # authorize Admin
      @admin = Admin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.require(:admin).permit(:name, :email, :username, :status, :role, :branch_id, :password, :password_confirmation)
    end
  end
end
