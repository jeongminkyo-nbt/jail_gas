class DelivariesController < ApplicationController
  before_action :set_delivary, only: [:show, :edit, :update, :destroy]
  before_action :set_auth, only: [:edit, :new]
  before_action :authenticate_user!, only: [:show, :index, :edit, :update, :destroy]

  # GET /delivaries
  # GET /delivaries.json
  def index
    page = params[:page].blank? ? 1 : params[:page]
    where_clause = Delivary.make_where_clause(params)

    @delivaries = Delivary.find_delivary_list(page, where_clause)
    @delivaries_all = Delivary.all
    authorize_action_for @delivaries

    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="배달_장부.xlsx"' }
    end
  end

  # GET /delivaries/1
  # GET /delivaries/1.json
  def show
  end

  # GET /delivaries/new
  def new

  end

  # GET /delivaries/1/edit
  def edit
  end

  # POST /delivaries
  # POST /delivaries.json
  def create
    @delivary = Delivary.new(delivary_params)
    @delivary.status = 0
    respond_to do |format|
      if @delivary.save()
        format.html { redirect_to delivaries_path, notice: '배달장부가 성공적으로 생성되었습니다.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /delivaries/1
  # PATCH/PUT /delivaries/1.json
  def update
    respond_to do |format|
      if @delivary.update(delivary_params)
        format.html { redirect_to @delivary, notice: '배달장부가 수정되었습니다.' }
        format.json { render :show, status: :ok, location: @delivary }
      else
        format.html { render :edit }
        format.json { render json: @delivary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivaries/1
  # DELETE /delivaries/1.json
  def destroy
    @delivary.destroy
    respond_to do |format|
      format.html { redirect_to delivaries_url, notice: 'Delivary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivary
      @delivary = Delivary.find(params[:id])
    end

    def set_auth
      if params[:id].present?
        @delivary = Delivary.find(params[:id])
        authorize_action_for @delivary
      else
        @delivary = Delivary.new
        authorize_action_for @delivary
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivary_params
      params.require(:delivary).permit(:date, :name, :product_name, :product_num, :deliver)
    end
end
