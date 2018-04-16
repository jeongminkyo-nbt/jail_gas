class ReceiveCreditsController < ApplicationController
  before_action :authenticate_user!, only: [:receive_index, :recent_index, :receive_return, :recent_return]

  def recent_index
    page = params[:page].blank? ? 1 : params[:page]
    params[:value] = 2
    where_clause = Credit.make_where_clause(params)

    @credits = Credit.find_credit_list(page, where_clause)
    @credits_all = Credit.where('status = 1')
    authorize_action_for @credits

    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="외상_수금_장부.xlsx"' }
    end
  end

  def receive_index
    page = params[:page].blank? ? 1 : params[:page]
    params[:value] = 1
    where_clause = Credit.make_where_clause(params)

    @credits = Credit.find_credit_list(page, where_clause)
    authorize_action_for @credits
    respond_to do |format|
      format.html
    end
  end

  def recent_return
    if params[:credit_ids].present?
      if params[:return_credits].present?
        payment_ids = params[:credit_ids]
        payment_ids.each do |id|
          index = id.to_i
          pay = Credit.find_by(id: index)
          authorize_action_for(pay)
          pay.update(status: nil)
        end

        respond_to do |format|
          format.html { redirect_to recent_credits_url, notice: '복구가 성공적으로 이루어졌습니다.' }
        end
      end
    else
    respond_to do |format|
      format.html { redirect_to recent_credits_url, notice: '복구가 목록을 선택하세요.' }
      end
    end
  end

  def receive_return
    if params[:credit_ids].present?
      if params[:return_credits].present?
        payment_ids = params[:credit_ids]
        payment_ids.each do |id|
          index = id.to_i
          pay = Credit.find_by(id: index)
          authorize_action_for(pay)
          pay.update(status: 1)
        end

        respond_to do |format|
          format.html { redirect_to receive_credits_url, notice: '수금이 정상적으로 이루어졌습니다.' }
        end
      end
    else
    respond_to do |format|
      format.html { redirect_to receive_credits_url, notice: '수금할 목록을 선택하세요.' }
      end
    end
  end

end

