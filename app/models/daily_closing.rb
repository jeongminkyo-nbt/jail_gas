class DailyClosing < ApplicationRecord
  has_many :delivaries
  has_many :credits
end
