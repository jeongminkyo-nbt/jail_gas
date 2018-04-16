class Config < ApplicationRecord
  resourcify
  include Authority::Abilities
  validates :cost,  presence: true
end
