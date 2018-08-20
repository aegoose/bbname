module Backend
  class AreasController < Backend::ApplicationController
    respond_to :html, :json
    before_action :set_area, only: [:show, :edit, :update, :destroy]

    add_breadcrumb I18n.t("navs.backend.areas"), :backend_areas_path

    # GET /areas
    # GET /areas.json
    def index
      @qr = params.fetch(:query, {}).permit(:key, :zone, :depth, :parent_id)
      @qr = @qr.select{|k,v| {k=>v} unless v.blank? }

      pid = params[:parent_id]
      unless pid.blank?
        @parent = Area.find(pid)
      else
        # @parent = Area.dg_city
        # pid=@parent.id
      end

      if @qr[:parent_id].blank? && !pid.blank?
        @qr[:parent_id] = pid # params[:parent_id]
      end

      # puts @qr

      if @qr.keys.blank?
        @qr[:zone] = Area.zone.province.value
      end

      qrkey = @qr.delete(:key)

      @areas = Area.by_query(@qr).by_key(qrkey).order(:id).page(params[:page])
      @qr[:key] = qrkey

    end

    # GET /areas/1
    # GET /areas/1.json
    def show
    end

    # GET /areas/new
    def new
      @area = Area.new
    end

    # GET /areas/1/edit
    def edit
    end

    # POST /areas
    # POST /areas.json
    def create
      update
      # @area = Area.new(area_params)

      # respond_to do |format|
      #   if @area.save
      #     format.html { redirect_to [:backend, @area], notice: 'Area was successfully created.' }
      #     format.json { render :show, status: :created, location: [:backend, @area] }
      #   else
      #     format.html { render :new }
      #     format.json { render json: @area.errors, status: :unprocessable_entity }
      #   end
      # end
    end

    # PATCH/PUT /areas/1
    # PATCH/PUT /areas/1.json
    def update
      respond_to do |format|
        if @area.update(area_params)
          format.html { redirect_to [:backend, @area], notice: 'Area was successfully updated.' }
          format.json { render :show, status: :ok, location: [:backend, @area] }
        else
          format.html { render :edit }
          format.json { render json: @area.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /areas/1
    # DELETE /areas/1.json
    def destroy
      @area.destroy
      respond_to do |format|
        format.html { redirect_to backend_areas_url, notice: 'Area was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:name, :zone, :depth, :seq)
    end
  end
end
