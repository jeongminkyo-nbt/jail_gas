module DailyClosingHelper
  def change_product_name(product_name)
    str = ''
    case product_name
      when 'argon'
        str = '아르곤'
      when 'air'
        str = '산소'
      when 'butane'
        str = '부탄'
      when '10kg'
        str = '10kg'
      when '20kg'
        str = '20kg'
      when '50kg'
        str = '50kg'
    end

    return str
  end
end
