class CreditsController < ApplicationController
  before_action :set_credit, only: [:show, :edit, :update, :destroy]
  before_action :set_auth, only: [:edit, :new]
  before_action :authenticate_user!, only: [:show, :index, :edit, :update, :destroy]
  # GET /credits
  # GET /credits.json
  def index
    page = params[:page].blank? ? 1 : params[:page]
    params[:value] = 1
    where_clause = Credit.make_where_clause(params)

    @credits = Credit.find_credit_list(page, where_clause)
    @credits_all = Credit.where('status is null')

    respond_to do |format|
     format.html
     format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="외상장부.xlsx"' }
    end

  end

  # GET /credits/1
  # GET /credits/1.json
  def show
  end

  # GET /credits/new
  def new

  end

  # GET /credits/1/edit
  def edit
  end

  # POST /credits
  # POST /credits.json
  def create
    @credit = Credit.new(credit_params)

    respond_to do |format|
      if @credit.save
        format.html { redirect_to credits_url, notice: '외상목록이 성공적으로 생성되었습니다.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /credits/1
  # PATCH/PUT /credits/1.json
  def update
    respond_to do |format|
      if @credit.update(credit_params)
        format.html { redirect_to @credit, notice: '외상장부가 성공적으로 수정되었습니다.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /credits/1
  # DELETE /credits/1.json
  def destroy
    @credit.destroy
    respond_to do |format|
      format.html { redirect_to credits_url, notice: 'Credit was successfully destroyed.' }
    end
  end

  def payment
    if params[:id].present?
      pay = Credit.find_by(id: params[:id])
      pay.update(status: 1)
    end
    if
    respond_to do |format|
      format.html { redirect_to credits_url, notice: '외상납부가 성공적으로 이루어졌습니다.' }
    end
    else
      respond_to do |format|
        format.html { redirect_to credits_url, notice: '납부할 목록을 체크해주세요.' }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit
      @credit = Credit.find(params[:id])
    end

    def set_auth
      if params[:id].present?
        @credit = Credit.find(params[:id])
        authorize_action_for @credit
      else
        @credit = Credit.new
        authorize_action_for @credit
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_params
      params.require(:credit).permit(:date, :name, :cost, :status, :product_name, :product_num)
    end
end
