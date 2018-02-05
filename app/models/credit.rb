class Credit < ApplicationRecord
  validates :name, :date, :cost,  presence: true
end
