class DailyClosingDoneDelivary < ApplicationRecord
  belongs_to :daily_closing

  def self.get_done_all_daily_closing(daily_closing_id)
    DailyClosingDoneDelivary
        .select('product_name,sum(product_num) as product_num_all')
        .where('daily_closing_id = ?', daily_closing_id)
        .group('product_name')
  end
end
