class DailyClosingController < ApplicationController

  module Status
    Delivary_ready = 0
    Delivary_done = 1
    Delivary_checking = 2
    Delivary_credit = 3
  end

  def closing
    @delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], 0)
    @check_delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], 2)
    @credit_delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], 3)

    if params[:daily_closing_date].nil?

    end
  end

  def update_delivary
    if params[:delivary_ids].present?
      delivary_ids = params[:delivary_ids]
      delivary_ids.each do |delivary|
        index = delivary.to_i
        delivary = Delivary.find_by(id: index)
        delivary.update(status: Status::Delivary_checking)
      end
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_path(:deliver => params[:deliver] ) }
    end
  end

  def add_delivary
    if params[:date].present? && params[:name].present?
      name = params[:name]
      date = params[:date]
      product_name = params[:product_name]
      product_num = params[:product_num].to_i
      deliver = params[:deliver]
      status = Status::Delivary_ready

      @add_delivary = Delivary.new(:date => date, :name => name, :product_name => product_name, :product_num => product_num, :deliver => deliver, :status => status)

      respond_to do |format|
        begin @add_delivary.save!
        format.html { redirect_to daily_closing_path(:deliver => params[:deliver] ) }
        rescue
          format.html { redirect_to :back,  :flash => { :error => '오류가 발생했습니다.' } }
        end
      end
    end
  end

  def add_credit
    if params[:credits_ids].present?
      credits_ids = params[:credits_ids]
      credits_ids.each do |credit|
        index = credit.to_i
        delivary = Delivary.find_by(id: index)
        date = delivary.date
        name = delivary.name
        cost = Config.where('product_name = ?',delivary.product_name).first.cost * delivary.product_num
        status = nil
        product_name = delivary.product_name
        product_num = delivary.product_num
        @add_credit = Credit.new(:date => date, :name => name, :product_name => product_name, :product_num => product_num, :cost => cost, :status => status)
        delivary.update(status: Status::Delivary_credit)
      end
    end

    respond_to do |format|
      if @add_credit.save
        format.html { redirect_to daily_closing_path(:deliver => params[:deliver] ) }
      end
    end
  end
end
