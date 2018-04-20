class DailyClosingController < ApplicationController
  before_action :authenticate_user!, only: [:show, :index, :create, :closing, :destroy]

  LIST_PER_PAGE = 25

  def index
    page = params[:page].blank? ? 1 : params[:page]
    @daily_closing = DailyClosing.where('deliver= ?', params[:deliver]).order('id DESC').page(page).per(LIST_PER_PAGE)
    authorize_action_for @daily_closing
  end

  def show
    @delivary = DailyClosing.find_by_id(params[:id]).delivaries
    @credit = DailyClosing.find_by_id(params[:id]).credits
    @total_cost = DailyClosing.find_by_id(params[:id]).total_cost
    @daily_closing_done_delivary = DailyClosingDoneDelivary.get_done_all_daily_closing(params[:id])
  end

  def closing
    @delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], Delivary::Status::DELIVARY_READY)
    @check_delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], Delivary::Status::DELIVARY_CHECKING)
    @credit_delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], Delivary::Status::DELIVARY_CREDIT)
    @done_delivary = Delivary.where('deliver= ? and status = ? or status = ?',params[:deliver], Delivary::Status::DELIVARY_CHECKING, Delivary::Status::DELIVARY_CREDIT)
    @cost_delivary = Delivary.get_cost_all(params[:deliver])

    @total_cost = 0
    @cost_delivary.each do |delivary|
      if delivary.product_name == '아르곤'
        delivary.product_name = 'argon'
      elsif delivary.product_name == '산소'
        delivary.product_name = 'air'
      elsif delivary.product_name == '부탄'
        delivary.product_name = 'butane'
      end
      @total_cost += delivary.product_num_all.to_i * Config.where('product_name = ?',delivary.product_name).first.cost.to_i
    end
  end

  def create
    credit_delivary = Delivary.where('deliver = ? and status = ?', params[:deliver], Delivary::Status::DELIVARY_CREDIT)
    done_delivary = Delivary.where('deliver= ? and status = ? or status = ?',params[:deliver], Delivary::Status::DELIVARY_CHECKING, Delivary::Status::DELIVARY_CREDIT)
    check_delivary = Delivary.where('deliver= ? and status = ?',params[:deliver],Delivary::Status::DELIVARY_CHECKING)
    cost_delivary = Delivary.get_cost_all(params[:deliver])
    date = params[:report_date]
    deliver = params[:deliver]
    total_cost = 0

    #total cost 값 계산
    cost_delivary.each do |delivary|
      if delivary.product_name == '아르곤'
        delivary.product_name = 'argon'
      elsif delivary.product_name == '산소'
        delivary.product_name = 'air'
      elsif delivary.product_name == '부탄'
        delivary.product_name = 'butane'
      end
      total_cost += delivary.product_num_all.to_i * Config.where('product_name = ?',delivary.product_name).first.cost.to_i
    end

    ApplicationRecord.transaction do
      @add_daily_closing = DailyClosing.new(:date => date, :deliver => deliver, :total_cost => total_cost)
      @add_daily_closing.save!

      #배달 목록들 관계 설정
      check_delivary.each do |delivary|
        product_name = delivary.product_name
        product_num = delivary.product_num
        daily_closing_id = @add_daily_closing.id
        @daily_closing_done_delivary = DailyClosingDoneDelivary.new(:product_name => product_name, :product_num => product_num, :daily_closing_id => daily_closing_id)
        @daily_closing_done_delivary.save!
      end

      #외상목록 생성
      credit_delivary.each do |delivary|
        date = delivary.date
        name = delivary.name
        product_name_ko = delivary.product_name
        if delivary.product_name == '아르곤'
          delivary.product_name = 'argon'
        elsif delivary.product_name == '산소'
          delivary.product_name = 'air'
        elsif delivary.product_name == '부탄'
          delivary.product_name = 'butane'
        end
        cost = Config.where('product_name = ?',delivary.product_name).first.cost.to_i * delivary.product_num
        status = nil
        product_num = delivary.product_num
        daily_closing_id = @add_daily_closing.id

        @add_credit = Credit.new(:date => date, :name => name, :cost => cost, :status => status, :product_name => product_name_ko, :product_num => product_num, :daily_closing_id => daily_closing_id)
        @add_credit.save!
      end

      # 창고 갯수 수정 밑 히스토리 기록
      all_delivary_done = Delivary.get_delivary_all(params[:deliver])
      gas_10kg = 0
      gas_20kg = 0
      gas_50kg = 0
      air = 0
      butane = 0
      argon = 0
      all_delivary_done.each do |delivary|
        if delivary.product_name == '10kg'
          gas_10kg = delivary.product_num_all
        elsif delivary.product_name == '20kg'
          gas_20kg = delivary.product_num_all
        elsif delivary.product_name == '50kg'
          gas_50kg = delivary.product_num_all
        elsif delivary.product_name == '산소'
          air = delivary.product_num_all
        elsif delivary.product_name == '부탄'
          butane = delivary.product_num_all
        elsif delivary.product_name == '아르곤'
          argon = delivary.product_num_all
        end
      end

      Config.update_count(gas_10kg, gas_20kg, gas_50kg, air, butane, argon, Warehouse::Status::OUT)
      @warehouse = Warehouse.new(:date => date, :gas_10kg => gas_10kg, :gas_20kg => gas_20kg, :gas_50kg => gas_50kg, :air => air, :butane =>butane, :argon => argon, :status => Warehouse::Status::OUT, :manager => params[:deliver], :daily_closing_id => @add_daily_closing.id)
      @warehouse.save!

      done_delivary.each do |delivary|
        delivary.update!(status: Delivary::Status::DELIVARY_DONE, daily_closing_id: @add_daily_closing.id)
      end
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_path(:deliver => params[:deliver] ) }
    end

  rescue => e
    respond_to do |format|
      format.html { redirect_to daily_closing_path(:deliver => params[:deliver] ), :flash => { :error => '오류가 발생했습니다.' } }
    end
  end

  def edit
    @delivary = DailyClosing.find_by_id(params[:id]).delivaries
    @credit = DailyClosing.find_by_id(params[:id]).credits
    @total_cost = 0
    @daily_closing_done_delivary = DailyClosingDoneDelivary.get_done_all_daily_closing_edit(params[:id])
    @daily_closing_done_delivary.each do |delivary|
      if delivary['product_name'] == '아르곤'
        delivary['product_name'] = 'argon'
      elsif delivary['product_name'] == '산소'
        delivary['product_name'] = 'air'
      elsif delivary['product_name'] == '부탄'
        delivary['product_name'] = 'butane'
      end
      @total_cost += delivary['sum(product_num)'].to_i * Config.where('product_name = ?',delivary['product_name']).first.cost.to_i
    end
  end



  def update_delivary
    if params[:delivary].to_i == 0 # 외상 생성
      if params[:delivary_ids].present?
        delivary_ids = params[:delivary_ids]
        Delivary.transaction do
          delivary_ids.each do |delivary|
            index = delivary.to_i
            deliv = Delivary.find_by(id: index)
            deliv.update!(status: Delivary::Status::DELIVARY_CHECKING)
          end
        end
      end
    elsif params[:delivary].to_i == 1 # 복구
      if params[:delivary_ids].present?
        delivary_ids = params[:delivary_ids]
        Delivary.transaction do
          delivary_ids.each do |delivary|
            index = delivary.to_i
            deliv = Delivary.find_by(id: index)
            deliv.destroy!
          end
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_report_path(:deliver => params[:deliver] ) }
    end

  rescue => e
    respond_to do |format|
      format.html { redirect_to daily_closing_report_path(:deliver => params[:deliver] ), :flash => { :error => '오류가 발생했습니다.' } }
    end
  end

  def edit_delivary #완료
    if params[:delivary].to_i == 0 # 외상 생성
      if params[:delivary_ids].present?
        delivary_ids = params[:delivary_ids]
        ApplicationRecord.transaction do
          delivary_ids.each do |delivary|
            index = delivary.to_i
            deliv = Delivary.find_by(id: index)
            deliv.update!(status: Delivary::Status::DELIVARY_CREDIT)
            date = deliv.date
            name = deliv.name
            product_name_ko = deliv.product_name
            if deliv.product_name == '아르곤'
              deliv.product_name = 'argon'
            elsif deliv.product_name == '산소'
              deliv.product_name = 'air'
            elsif deliv.product_name == '부탄'
              deliv.product_name = 'butane'
            end
            cost = Config.where('product_name = ?',deliv.product_name).first.cost.to_i * deliv.product_num
            status = nil
            product_num = deliv.product_num
            daily_closing_id = params[:id]
            @add_credit = Credit.new(:date => date, :name => name, :cost => cost, :status => status, :product_name => product_name_ko, :product_num => product_num, :daily_closing_id => daily_closing_id)
            @add_credit.save!
          end
        end
      end
    elsif params[:delivary].to_i == 1 # 복구
      if params[:delivary_ids].present?
        delivary_ids = params[:delivary_ids]
        Delivary.transaction do
          delivary_ids.each do |delivary|
            index = delivary.to_i
            deliv = Delivary.find_by(id: index)
            deliv.destroy!
          end
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_edit_path(:id => params[:id], :deliver => params[:deliver] ) }
    end

  rescue => e
    respond_to do |format|
      format.html { redirect_to daily_closing_edit_path(:id => params[:id], :deliver => params[:deliver] ), :flash => { :error => '오류가 발생했습니다.' } }
    end
  end

  def add_delivary # 완료
    if params[:date].present? && params[:name].present?
      name = params[:name]
      date = params[:date]
      product_name = params[:product_name]
      product_num = params[:product_num].to_i
      deliver = params[:deliver]
      status = Delivary::Status::DELIVARY_READY
      if params[:delivary].to_i == 1 # 수정시
        daily_closing_id = params[:id].to_i
        status = Delivary::Status::DELIVARY_EDIT
        @add_delivary = Delivary.new(:date => date, :name => name, :product_name => product_name, :product_num => product_num, :deliver => deliver, :status => status, :daily_closing_id => daily_closing_id)

        respond_to do |format|
          begin @add_delivary.save!
          format.html { redirect_to daily_closing_edit_path(:id => params[:id], :deliver => params[:deliver] ) }
          rescue
            format.html { redirect_to :back,  :flash => { :error => '오류가 발생했습니다.' } }
          end
        end
      elsif params[:delivary].to_i == 0 # 생성시
        @add_delivary = Delivary.new(:date => date, :name => name, :product_name => product_name, :product_num => product_num, :deliver => deliver, :status => status)
        respond_to do |format|
          begin @add_delivary.save!
          format.html { redirect_to daily_closing_report_path(:deliver => params[:deliver] ) }
          rescue
            format.html { redirect_to :back,  :flash => { :error => '오류가 발생했습니다.' } }
          end
        end
      end
    end
  end

  def update_credit # 완료
    if params[:credit].to_i == 1 # 외상목록에 있는 내용을 외상체크로 복구
      if params[:return_credits_ids].present?
        return_credits_ids = params[:return_credits_ids]
        Delivary.transaction do
          return_credits_ids.each do |credit|
            index = credit.to_i
            delivary = Delivary.find_by(id: index)
            delivary.update!(status: Delivary::Status::DELIVARY_CHECKING)
          end
        end
      end
    elsif params[:credit].to_i == 2 # 외상체크에있는 내용을 배달목록으로 복구
      if params[:credits_ids].present?
        credits_ids = params[:credits_ids]
        Delivary.transaction do
          credits_ids.each do |credit|
            index = credit.to_i
            delivary = Delivary.find_by(id: index)
            delivary.update!(status: Delivary::Status::DELIVARY_READY)
          end
        end
      end
    elsif params[:credit].to_i == 3 # 외상체크에 있는 내용을 외상목록으로 넘김
      if params[:credits_ids].present?
        credits_ids = params[:credits_ids]
        Delivary.transaction do
          credits_ids.each do |credit|
            index = credit.to_i
            delivary = Delivary.find_by(id: index)
            delivary.update!(status: Delivary::Status::DELIVARY_CREDIT)
          end
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_report_path(:deliver => params[:deliver] ) }
    end

  rescue => e
    respond_to do |format|
      format.html { redirect_to daily_closing_report_path(:deliver => params[:deliver] ),:flash => { :error => '오류가 발생했습니다.' } }
    end
  end

  def delete_credit # 완료
    Delivary.transaction do
      if params[:return_credits_ids].present?
        return_credits_ids = params[:return_credits_ids]
        return_credits_ids.each do |credit|
          index = credit.to_i
          delivary = Credit.find_by(id: index)
          delivary.destroy!
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_edit_path(:id => params[:id], :deliver => params[:deliver] ) }
    end
  rescue => e
    respond_to do |format|
      format.html { redirect_to daily_closing_edit_path(:id => params[:id], :deliver => params[:deliver] ), :flash => { :error => '오류가 발생했습니다.' } }
    end
  end

  def edit_closing
    @daily_closing_done_delivary = DailyClosingDoneDelivary.get_done_all_daily_closing_edit(params[:id])
    total_cost = 0
    @daily_closing_done_delivary.each do |delivary|
      if delivary['product_name'] == '아르곤'
        delivary['product_name'] = 'argon'
      elsif delivary['product_name'] == '산소'
        delivary['product_name'] = 'air'
      elsif delivary['product_name'] == '부탄'
        delivary['product_name'] = 'butane'
      end
      total_cost += delivary['sum(product_num)'].to_i * Config.where('product_name = ?',delivary['product_name']).first.cost.to_i
    end

    @done_delivary = Delivary.where('status = ? or status = ?', Delivary::Status::DELIVARY_CREDIT, Delivary::Status::DELIVARY_EDIT)
    ApplicationRecord.transaction do
      @done_delivary.each do |delivary|
        if delivary.status == 4
          product_name = delivary.product_name
          product_num = delivary.product_num
          daily_closing_id = params[:id]
          @daily_closing_done_delivary = DailyClosingDoneDelivary.new(:product_name => product_name, :product_num => product_num, :daily_closing_id => daily_closing_id)
          @daily_closing_done_delivary.save!
        end
        delivary.update!(status: Delivary::Status::DELIVARY_DONE)
      end

      @daily_closing = DailyClosing.find_by_id(params[:id])
      @daily_closing.update!(total_cost: total_cost)

      get_delivary_done = Delivary.get_done_all_daily_closing(params[:id])
      gas_10kg = 0
      gas_20kg = 0
      gas_50kg = 0
      air = 0
      butane = 0
      argon = 0
      get_delivary_done.each do |delivary|
        if delivary.product_name == '10kg'
          gas_10kg = delivary.product_num_all
        elsif delivary.product_name == '20kg'
          gas_20kg = delivary.product_num_all
        elsif delivary.product_name == '50kg'
          gas_50kg = delivary.product_num_all
        elsif delivary.product_name == '산소'
          air = delivary.product_num_all
        elsif delivary.product_name == '부탄'
          butane = delivary.product_num_all
        elsif delivary.product_name == '아르곤'
          argon = delivary.product_num_all
        end
      end

      @warehouse = Warehouse.find_by_daily_closing_id(params[:id].to_i)
      Config.update_count(gas_10kg.to_i - @warehouse.gas_10kg.to_i, gas_20kg.to_i - @warehouse.gas_20kg.to_i, gas_50kg.to_i - @warehouse.gas_50kg.to_i, air.to_i - @warehouse.air.to_i, butane.to_i - @warehouse.butane.to_i, argon.to_i - @warehouse.argon.to_i, Warehouse::Status::OUT)
      @warehouse.update!(gas_10kg: gas_10kg, gas_20kg: gas_20kg, gas_50kg: gas_50kg, air: air, butane: butane, argon: argon)
    end

    respond_to do |format|
      format.html { redirect_to daily_closing_show_path(:id => params[:id], :deliver => params[:deliver] ) }
    end

  rescue => e
    respond_to do |format|
      format.html { redirect_to daily_closing_show_path(:id => params[:id], :deliver => params[:deliver] ), :flash => { :error => '오류가 발생했습니다.' } }
    end
  end
end
