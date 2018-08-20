# -*- encoding : utf-8 -*-
module Backend
  class TagKeysController < Backend::ApplicationController
    before_action :set_tag_key, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json
    add_breadcrumb I18n.t("navs.backend.tag_keys"), :backend_tag_keys_path

    # GET /backend/tag_keys
    # GET /backend/tag_keys.json
    def index
      @qr = params.fetch(:query, {}).permit(:catg_id, :key)
      @qr = @qr.select{|k,v| {k=>v} unless v.blank? }
      if @qr[:catg_id].blank? && !params[:catg_id].blank?
        @qr[:catg_id] = params[:catg_id]
      end

      # binding.pry
      qrkey = @qr.delete(:key)
      @tag_keys = TagKey.by_query(@qr).by_key(qrkey).order(:seq).page(params[:page])

      @qr[:key] = qrkey

    end

    # GET /backend/tag_keys/1
    # GET /backend/tag_keys/1.json
    def show
    end

    # GET /backend/tag_keys/new
    def new
      @tag_key = TagKey.new
      respond_modal_with @tag_key
    end

    # GET /backend/tag_keys/1/edit
    def edit
      respond_modal_with @tag_key
    end

    # POST /backend/tag_keys
    # POST /backend/tag_keys.json
    def create
      update
      # render :update
    end

    # PATCH/PUT /backend/tag_keys/1
    # PATCH/PUT /backend/tag_keys/1.json
    def update
      pam = tag_key_params

      if @tag_key.blank?
        @tag_key = TagKey.new(pam)
      else
        @tag_key.attributes = pam
      end

      isOk = @tag_key.save

      raise ApiCatgErrors::CatgTagKeyUpdateError.new(@tag_key.error_messages) unless isOk

      # respond_to :json
      # remote:true, type: :json,
      respond_to do |format|
        format.html { redirect_to backend_tag_keys_url, notice: '更新成功!' }
        format.json { render :update }
      end
    end
    def new_import
      @tag_key = TagKey.new(id:0)
    end

    def import
      pam = tag_key_params
      catg_id = pam[:catg_id]
      namestr = pam[:name]

      newseq = (TagKey.maximum(:seq) || 0)+1
      fails = []
      suces = []
      namestr.split(/\s+/).each do |name|
        name = name&.strip
        unless name.blank?
          lk = TagKey.new(name: name, catg_id: catg_id, seq:newseq)
          if lk.save
            suces << name
            newseq += 1
          else
            fails<<name
          end
        end
      end

      @errmsg = suces.length <= 0 ? "有0条导入成功" : "[#{suces.join(",")}]导入成功"

      if fails.length > 0
        @errmsg += ",[" + fails.join(",") + "]没有导入成功"
        # raise ApiCatgErrors::CatgTagKeyUpdateError.new(@errmsg)
      end

      respond_to do |format|
        format.html { redirect_to backend_tag_keys_url(catg_id:catg_id), notice: @errmsg }
        format.json { render :import }
      end

    end

    # DELETE /backend/tag_keys/1
    # DELETE /backend/tag_keys/1.json
    def destroy
      @tag_key.destroy
      respond_to do |format|
        format.html { redirect_to backend_tag_keys_url, notice: '删除成功!' }
        format.json { render :destroy }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag_key
      @tag_key = TagKey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_key_params
      params.require(:tag_key).permit(:name, :catg_id, :seq)
    end
  end
end
