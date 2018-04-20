module DelivariesHelper

  def get_status(delivary_status)
    if delivary_status == 0
      status = '미완료'
    elsif delivary_status == 1
      status = '정산중'
    elsif delivary_status == 2
      status = '외상장부 생성중'
    else
      status = '배달 완료'
    end
    status
  end

end

