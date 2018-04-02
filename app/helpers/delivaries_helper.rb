module DelivariesHelper

  def get_status(delivary_status)
    if delivary_status == false
      status = '미완료'
    else
      status = '완료'
    end
    status
  end

end
