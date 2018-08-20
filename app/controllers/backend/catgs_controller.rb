module Backend
  class CatgsController < Backend::ApplicationController
    respond_to :html, :json
    before_action :set_catg, only: [:show, :edit, :update, :destroy]

    add_breadcrumb I18n.t("navs.backend.catgs"), :backend_catgs_path

    # GET /catgs
    # GET /catgs.json
    def index
      @qr =  params.fetch(:query){ Hash.new }.permit(:key, :status)
      @qr = @qr.select { |k,v| {k => v} unless v.blank? }
      # if @qr[:catg_id].blank? && !params[:catg_id].blank?
      #   @qr[:catg_id] = params[:catg_id]
      # end
      qrkey = @qr.delete(:key)
      @catgs = Catg.by_query(@qr).by_key(qrkey).order(:seq).page(params[:page])
      @qr[:key] = qrkey
      # binding.pry
    end

    def selects
      self.index
      @select = !!params[:select]
    end

    # GET /catgs/1
    # GET /catgs/1.json
    def show
    end

    # GET /catgs/new
    def new
      @catg = Catg.new
      respond_modal_with @catg
    end

    # GET /catgs/1/edit
    def edit
      respond_modal_with @catg
    end

    # POST /catgs
    # POST /catgs.json
    def create

      update

      # render :update

    end

    # PATCH/PUT /catgs/1
    # PATCH/PUT /catgs/1.json
    def update

      pam = catg_params

      if @catg.blank?
        @catg = Catg.new(pam)
      else
        @catg.attributes = pam
      end

      isOk = @catg.save

      raise ApiCatgErrors::CatgUpdateFail.new(@catg.error_messages) unless isOk

      # respond_to :json
      respond_to do |format|
        format.html { redirect_to backend_catgs_url, notice: '保存成功!' }
        format.json { render :update }
      end

    end

    # DELETE /catgs/1
    # DELETE /catgs/1.json
    def destroy
      @catg.destroy
      respond_to do |format|
        format.html { redirect_to backend_catgs_url, notice: '删除成功!' }
        format.json { render :destroy }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_catg
      @catg = Catg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catg_params
      params.require(:catg).permit(:name, :seq)
    end
  end
end
