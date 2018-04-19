module WarehouseHelper

  def show_status(status)
    if status == 0
      show_status = '입고'
    else
      show_status = '출고'
    end
    show_status
  end
end
