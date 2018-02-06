class CreditsController < ApplicationController
  before_action :set_credit, only: [:show, :edit, :update, :destroy]

  # GET /credits
  # GET /credits.json
  def index
    @credits = Credit.where(status: nil)
  end

  # GET /credits/1
  # GET /credits/1.json
  def show
  end

  # GET /credits/new
  def new
    @credit = Credit.new
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
        format.html { redirect_to @credit, notice: 'Credit was successfully updated.' }
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
    if params[:credit_ids].present?
      if params[:pay_credits].present?
        payment_ids = params[:credit_ids]
        payment_ids.each do |id|
          index = id.to_i
          pay = Credit.find_by(id: index)
          pay.update(status: 1)
        end
        respond_to do |format|
          format.html { redirect_to credits_url, notice: '외상납부가 성공적으로 이루어졌습니다.' }
        end
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_params
      params.require(:credit).permit(:date, :name, :cost, :status, :product_name)
    end
end
