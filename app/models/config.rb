class Config < ApplicationRecord
  resourcify
  include Authority::Abilities
  validates :cost,  presence: true

  def self.update_count(gas_10kg, gas_20kg, gas_50kg, air, butane, argon, status)
    arr = Array.new
    arr.push(gas_10kg)
    arr.push(gas_20kg)
    arr.push(gas_50kg)
    arr.push(air)
    arr.push(butane)
    arr.push(argon)

    if status.to_i == Warehouse::Status::INSERT
      Config.transaction do
        (1..6).each do |index|
          if arr[index-1] != 0
            count = Config.find_by_id(index).count + arr[index-1].to_i
            Config.find_by_id(index).update!(count: count)
          end
        end
      end
    elsif status.to_i == Warehouse::Status::OUT
      Config.transaction do
        (1..6).each do |index|
          if arr[index-1] != 0
            count = Config.find_by_id(index).count - arr[index-1].to_i
            Config.find_by_id(index).update!(count: count)
          end
        end
      end
    end
  end

end
