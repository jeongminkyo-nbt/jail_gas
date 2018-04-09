class DailyClosingController < ApplicationController

  LIST_PER_PAGE = 25

  module Status
    Delivary_ready = 0
    Delivary_checking = 1
    Delivary_credit = 2
    Delivary_done = 3
  end

  def index
    page = params[:page].blank? ? 1 : params[:page]
    @daily_closing = DailyClosing.where('deliver= ?', params[:deliver]).page(page).per(LIST_PER_PAGE)
  end

  def show
    @delivary = DailyClosing.find_by_id(params[:id]).delivaries

  end

  def closing
    @delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], 0)
    @check_delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], 1)
    @credit_delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], 2)
    @done_delivary = Delivary.where('deliver= ? and status = ? or status = ?',params[:deliver], 1, 2)
    @all_delivary = Delivary.get_total_all(params[:deliver])

    @total_cost = 0
    @all_delivary.each do |delivary|
      if delivary.product_name == '아르곤'
        delivary.product_name = 'argon'
      elsif delivary.product_name == '산소'
        delivary.product_name = 'air'
      elsif delivary.product_name == '부탄'
        delivary.product_name = 'butane'
      end
      @total_cost += delivary.product_num_all.to_i * Config.where('product_name = ?',delivary.product_name).first.cost.to_i
    end

    if params[:daily_closing_date].nil?

    end
  end

  def update_delivary
    if params[:delivary].to_i == 0
      if params[:delivary_ids].present?
        delivary_ids = params[:delivary_ids]
        delivary_ids.each do |delivary|
          index = delivary.to_i
          delivary = Delivary.find_by(id: index)
          delivary.update(status: Status::Delivary_checking)
        end
      end
    elsif params[:delivary].to_i == 1
      if params[:delivary_ids].present?
        delivary_ids = params[:delivary_ids]
        delivary_ids.each do |delivary|
          index = delivary.to_i
          deliv = Delivary.find_by(id: index)
          deliv.destroy # TODO: 찾은 delivary 삭제 필요
        end
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

  def update_credit
    if params[:credit].to_i == 1 # 외상목록에 있는 내용을 외상체크로 복구
      if params[:return_credits_ids].present?
        return_credits_ids = params[:return_credits_ids]
        return_credits_ids.each do |credit|
          index = credit.to_i
          delivary = Delivary.find_by(id: index)
          delivary.update(status: Status::Delivary_checking)
          #TODO: credit에 생성되는 것을 삭제해야됨
        end
      end
    elsif params[:credit].to_i == 2 # 외상체크에있는 내용을 배달목록으로 복구
      if params[:credits_ids].present?
        credits_ids = params[:credits_ids]
        credits_ids.each do |credit|
          index = credit.to_i
          delivary = Delivary.find_by(id: index)
          delivary.update(status: Status::Delivary_ready)
        end
      end
    elsif params[:credit].to_i == 3 # 외상체크에 있는 내용을 외상목록으로 넘김
      if params[:credits_ids].present?
        credits_ids = params[:credits_ids]
        credits_ids.each do |credit|
          index = credit.to_i
          delivary = Delivary.find_by(id: index)
          delivary.update(status: Status::Delivary_credit)

        end
      end
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_path(:deliver => params[:deliver] ) }
    end
  end
end
