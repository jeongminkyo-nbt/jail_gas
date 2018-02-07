class ReceiveCreditsController < ApplicationController

  def recent_index
    page = params[:page].blank? ? 1 : params[:page]
    params[:value] = 2
    where_clause = Credit.make_where_clause(params)

    @credits = Credit.find_credit_list(page, where_clause)

    respond_to do |format|
      format.html
    end
  end

  def receive_index
    page = params[:page].blank? ? 1 : params[:page]
    params[:value] = 1
    where_clause = Credit.make_where_clause(params)

    @credits = Credit.find_credit_list(page, where_clause)

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
          pay.update(status: nil)
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to recent_credits_url, notice: 'Credit was successfully created.' }
    end
  end

  def receive_return
    if params[:credit_ids].present?
      if params[:return_credits].present?

        payment_ids = params[:credit_ids]
        payment_ids.each do |id|
          index = id.to_i
          pay = Credit.find_by(id: index)
          pay.update(status: 1)
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to receive_credits_url, notice: 'Credit was successfully created.' }
    end
  end
end

