module ConfigHelper

  def change_name(id)
    str = ''
    case id
      when 1
        str = '10kg'
      when 2
        str = '20kg'
      when 3
        str = '50kg'
      when 4
        str = '산소'
      when 5
        str = '부탄'
      when 6
        str = '아르곤'
      when 7
        str = '가스 기화기 부담금'
      when 8
        str = '사택 단위금'
    end

    return str
  end
end
