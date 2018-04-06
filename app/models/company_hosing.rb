class CompanyHosing < ApplicationRecord
  validates :name, :dong, :ho, :call, :prev_month, :current_month, :usage, :share, :usage_money, presence: true

  PER_MONEY = Config.find_by_id(8).cost
  SHARE = Config.find_by_id(7).cost

  def update_current_month(id, current_month)
    @ompany_hosing = self.find_by(id)
    current_month = current_month
    prev_month = @ompany_hosing.current_month.to_i
    current_usage = current_month.to_i - prev_month
    current_usage_money = current_usage * PER_MONEY + SHARE
    CompanyHosing.transaction do
      if current_month.present?
        company_hosing.update_attributes(:usage => current_usage.to_i, :usage_money => current_usage_money.to_i, :prev_month => prev_month, :current_month => current_month, :share => SHARE)
      end
    end

  rescue => e

  end

  def update_people(dong, ho, name, call, prev_month, current_month)
    usage = current_month.to_i - prev_month.to_i
    share = SHARE
    usage_money = usage * PER_MONEY + SHARE

    CompanyHosing.transaction do
      @company_housing = self.save(:dong => dong, :ho => ho, :name => name, :call => call, :prev_month => prev_month, :current_month => current_month, :usage => usage, :share => share, :usage_money => usage_money)
    end
  end

end
