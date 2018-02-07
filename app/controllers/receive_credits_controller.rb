class ReceiveCreditsController < ApplicationController

  def index
    @credits = Credit.where(status: 1)
  end

  def index_
    @credits = Credit.where(status: nil)
  end

  def return
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

  def return_
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

