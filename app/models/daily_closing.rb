class DailyClosing < ApplicationRecord
  has_many :delivaries
  has_many :credits
  has_many :daily_closing_done_delivaries
end
