class WarehouseController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    page = params[:page].blank? ? 1 : params[:page]
    where_clause = Warehouse.make_where_clause(params)

    @warehouses = Warehouse.find_warehouse_list(page, where_clause)

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
