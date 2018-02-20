class ConfigController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @config = Config.first
    respond_to do |format|
      format.html
      end
  end

  def edit
    @config = Config.first
    authorize_action_for @config
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
