class DailyClosing < ApplicationRecord
  has_many :delivaries
  has_many :credits
  has_many :daily_closing_done_delivaries
  has_one :warehouse

  resourcify
  include Authority::Abilities
  validates :date, :total_cost,  presence: true
end
