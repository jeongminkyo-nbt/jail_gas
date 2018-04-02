class CompanyHosingController < ApplicationController
  before_action :authenticate_user!, only: [:company_hosing]

  def company_hosing
    if params[:select_dong].present?
      select_dong = params[:select_dong].first(3)
    else
      select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?',select_dong.to_i)

    respond_to do |format|
      format.html
    end
  end

  def edit
    if params[:select_dong].present?
      select_dong = params[:select_dong].first(3)
    else
      select_dong = 101
    end

    @company_housing = CompanyHosing.where('dong = ?',select_dong.to_i)
    
  end

  def update
    @config = Config.first

    respond_to do |format|
      if @config.update(params[:config].to_hash)
        format.html { redirect_to '/configs', notice: '설정이 성공적으로 수정되었습니다.' }
      else
        format.html { render :edit }
      end
    end
  end
end
