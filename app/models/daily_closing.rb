class DailyClosing < ApplicationRecord
  has_and_belongs_to_many :delivaries
end
