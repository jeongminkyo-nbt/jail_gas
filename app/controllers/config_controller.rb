class ConfigController < ApplicationController

  before_action :authenticate_user!, only: [:index]
  def index
    @config = Config.first

    respond_to do |format|
      format.html
      end
  end

  def new
  end

  def update
    @credit = Credit.new(credit_params)

    respond_to do |format|
      if @config.update(config_params)
        format.html { redirect_to @credit, notice: '설정이 성공적으로 수정되었습니다.' }
      else
        format.html { render :edit }
      end
    end
  end
end
