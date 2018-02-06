class ReceiveCreditsController < ApplicationController

  def index
    @credits = Credit.where(status: 1)
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
      format.html { redirect_to receive_credits_url, notice: 'Credit was successfully created.' }
    end
  end
end

