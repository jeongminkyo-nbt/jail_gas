class CompanyHosing < ApplicationRecord
  validates :name, :dong, :ho, :call, :prev_month, :current_month, :usage, :share, :usage_money, presence: true

  resourcify
  include Authority::Abilities

end
