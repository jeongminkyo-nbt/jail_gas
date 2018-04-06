class CompanyHosingController < ApplicationController
  before_action :authenticate_user!, only: [:company_hosing, :edit]

  PER_MONEY = Config.find_by_id(8).cost
  SHARE = Config.find_by_id(7).cost

  def company_hosing
    if params[:select_dong].present?
      @select_dong = params[:select_dong].first(3)
    else
      @select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?',@select_dong.to_i)

    respond_to do |format|
      format.html
    end
  end

  def edit
    if params[:select_dong].present?
      @select_dong = params[:select_dong].first(3)
    else
      @select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?', @select_dong.to_i)
    
  end

  # :TODO 업데이트 중 하나라도 에러가 나면 다 업데이트가 되지 않게 한다. model과 같이 봐야함
  def set_update
    params[:id].map do |row|
      company_hosing = CompanyHosing.find_by_id(row[0].to_i)
      current_month = row[1]
      prev_month = company_hosing.current_month.to_i
      current_usage = current_month.to_i - prev_month
      current_usage_money = current_usage * PER_MONEY + SHARE
      if current_month.present?
        company_hosing.update_attributes!(:usage => current_usage.to_i, :usage_money => current_usage_money.to_i, :prev_month => prev_month, :current_month => current_month, :share => SHARE)
        end
      end

    respond_to do |format|
      format.html { redirect_to company_housing_path, notice: '변경사항이 적용되었습니다.' }
    end
  end

  def add_people
    if params[:select_dong].present?
      @select_dong = params[:select_dong].first(3)
    else
      @select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?',@select_dong.to_i)

    respond_to do |format|
      format.html
    end
  end

  def update_people
    dong = params[:dong]
    ho = params[:ho]
    name = params[:name]
    call = params[:call]
    prev_month = params[:prev_month]
    current_month = params[:current_month]
    usage = current_month.to_i - prev_month.to_i
    share = SHARE
    usage_money = usage * PER_MONEY + SHARE
    @company_housing = CompanyHosing.new(:dong => dong, :ho => ho, :name => name, :call => call, :prev_month => prev_month, :current_month => current_month, :usage => usage, :share => share, :usage_money => usage_money)

    respond_to do |format|
      begin @company_housing.save!
        format.html { redirect_to company_housing_url, notice: '추가인원이 성공적으로 생성되었습니다.' }
      rescue
        format.html { redirect_to :back,  :flash => { :error => '오류가 발생했습니다.' } }
      end
    end
  end
end
