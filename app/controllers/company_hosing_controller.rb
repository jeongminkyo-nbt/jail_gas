class CompanyHosingController < ApplicationController
  before_action :authenticate_user!, only: [:company_hosing, :edit, :add_people]

  PER_MONEY = Config.find_by_id(8).cost
  SHARE = Config.find_by_id(7).cost

  def company_hosing
    if params[:select_dong].present?
      @select_dong = params[:select_dong].first(3)
    else
      @select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?',@select_dong.to_i)
    @company_housing_all = CompanyHosing.all

    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="사택_검침_장부.xlsx"' }
    end
  end

  def edit
    if params[:select_dong].present?
      @select_dong = params[:select_dong].first(3)
    else
      @select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?', @select_dong.to_i)
    authorize_action_for @company_housing
  end

  def edit_people
    @company_housing = CompanyHosing.find_by_id(params[:id])
  end

  def apply_edit_people
    if params[:dong].present? && params[:ho].present? && params[:name].present? &&params[:call].present? && params[:prev_month].present? && params[:current_month].present?
    dong = params[:dong]
    ho = params[:ho]
    name = params[:name]
    call = params[:call]
    prev_month = params[:prev_month]
    current_month = params[:current_month]
    usage = current_month.to_i - prev_month.to_i
    share = SHARE.to_i
    usage_money = usage * PER_MONEY.to_i + SHARE.to_i
    company_housing = CompanyHosing.find_by_id(params[:id])
    end

    respond_to do |format|
      begin company_housing.update_attributes!(:dong => dong, :ho => ho, :name => name, :call => call, :prev_month => prev_month, :current_month => current_month, :usage => usage, :share => share, :usage_money => usage_money)
      format.html { redirect_to company_housing_url, notice: '인원수정이 성공적으로 수행되었습니다.' }
      rescue
        format.html { redirect_to :back,  :flash => { :error => '오류가 발생했습니다.' } }
      end
    end
  end

  def set_update
    CompanyHosing.transaction do
      params[:id].map do |row|
        company_hosing = CompanyHosing.find_by_id(row[0].to_i)
        current_month = row[1]
        prev_month = company_hosing.current_month.to_i
        current_usage = current_month.to_i - prev_month
        current_usage_money = current_usage * PER_MONEY.to_i + SHARE.to_i
        if current_month.present?
          company_hosing.update_attributes!(:usage => current_usage.to_i, :usage_money => current_usage_money.to_i, :prev_month => prev_month, :current_month => current_month, :share => SHARE.to_i)
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to company_housing_path, notice: '변경사항이 적용되었습니다.' }
    end

    rescue => e
      respond_to do |format|
        format.html { redirect_to company_housing_path, :flash => { :error => '오류가 발생했습니다.' } }
      end
  end

  def add_people
    if params[:select_dong].present?
      @select_dong = params[:select_dong].first(3)
    else
      @select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?',@select_dong.to_i)
    authorize_action_for @company_housing

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
    share = SHARE.to_i
    usage_money = usage * PER_MONEY.to_i + SHARE.to_i
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
