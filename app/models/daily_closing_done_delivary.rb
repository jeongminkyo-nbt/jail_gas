class DailyClosingDoneDelivary < ApplicationRecord
  belongs_to :daily_closing

  def self.get_done_all_daily_closing(daily_closing_id)
    DailyClosingDoneDelivary
        .select('product_name,sum(product_num) as product_num_all')
        .where('daily_closing_id = ?', daily_closing_id)
        .group('product_name')
  end

  def self.get_done_all_daily_closing_edit(daily_closing_id)
    sql = "select product_name, sum(product_num)
           from (
                   (
                      select id,  product_name,product_num, daily_closing_id, created_at, updated_at
                      from delivaries
                      where daily_closing_id = #{daily_closing_id}
                      and status = 4
                   )
                   union
                   (
                      select *
                          from daily_closing_done_delivaries
                      where daily_closing_id = #{daily_closing_id}
                   )
                ) as temp
           group by product_name"
    result = ActiveRecord::Base.connection.exec_query(sql)
  end
end
