class CompanyHosingController < ApplicationController
  before_action :authenticate_user!, only: [:company_hosing, :edit]

  PER_MONEY = Config.first.per_money
  SHARE = Config.first.share

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

  def set_update
    str = ''
    params[:id].map do |row|
      company_hosing = CompanyHosing.find_by_id(row[0].to_i)
      current_month = row[1]
      prev_month = company_hosing.current_month.to_i
      current_usage = current_month.to_i - prev_month
      current_usage_money = current_usage * PER_MONEY + SHARE
      if current_month.present?
        company_hosing.update_attributes(:usage => current_usage.to_i, :usage_money => current_usage_money.to_i, :prev_month => prev_month, :current_month => current_month, :share => SHARE)
        str = '변경사항이 적용되었습니다.'
      else
        str = '오류가 발생했습니다.'
      end
    end

    respond_to do |format|
      format.html { redirect_to company_housing_path, notice: str }
    end
  end
end
