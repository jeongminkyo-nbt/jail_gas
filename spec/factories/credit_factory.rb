class CreditFactory
  FactoryBot.define do
    factory :Credit do
      date '2018-04-03'
      name { Faker::Internet.user_name }
      product_name '50kg'
      product_num {  Faker::Number.number(10).to_s }
      created_at '2010-01-01'
      updated_at '2010-01-01'
    end
  end
end
