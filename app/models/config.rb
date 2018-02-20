class Config < ApplicationRecord
  resourcify
  include Authority::Abilities
end
