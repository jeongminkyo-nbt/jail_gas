module DelivariesHelper

  def get_status(delivary_status)
    if delivary_status == 0
      status = '미완료'
    elsif delivary_status == 1
      status = '완료'
    else
      status = '정산중'
    end
    status
  end

end
