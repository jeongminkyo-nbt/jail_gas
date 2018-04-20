class WarehouseController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    page = params[:page].blank? ? 1 : params[:page]
    where_clause = Warehouse.make_where_clause(params)

    @warehouses = Warehouse.find_warehouse_list(page, where_clause)
    authorize_action_for @warehouses
    respond_to do |format|
      format.html
    end
  end

  def new

  end

  def edit
    @warehouse = Warehouse.find_by_id(params[:id])
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)
    Config.update_count(params[:gas_10kg], params[:gas_20kg], params[:gas_50kg], params[:air], params[:butane], params[:argon],params[:status])

    respond_to do |format|
      if @warehouse.save()
        format.html { redirect_to warehouse_path, notice: '입/출고가 성공적으로 생성되었습니다.' }
      else
        format.html { render :new, notice: 'error'}
      end
    end
  end

  def update
    @warehouse = Warehouse.find_by_id(params[:id])
    before = Warehouse.find_by_id(params[:id])

    Config.update_count(params[:gas_10kg].to_i - before.gas_10kg.to_i, params[:gas_20kg].to_i - before.gas_20kg.to_i, params[:gas_50kg].to_i - before.gas_50kg.to_i, params[:air].to_i - before.air.to_i, params[:butane].to_i - before.butane.to_i, params[:argon].to_i - before.argon.to_i,params[:status])

    respond_to do |format|
      if @warehouse.update(warehouse_params)
        format.html { redirect_to warehouse_path, notice: '입/출고가 수정되었습니다.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    def warehouse_params
      params.permit(:date, :gas_10kg, :gas_20kg, :gas_50kg, :air, :butane, :argon, :manager, :status)
    end
end
