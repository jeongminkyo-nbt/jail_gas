class DailyClosingController < ApplicationController

  def closing
    # @delivary = Delivary.where(deliver: '최득섭', status: false)
    @delivary = DailyClosing.find_by_id(params[:daily_closing_date]).delivaries
  end

  def index

  end
end
