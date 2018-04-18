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
end
