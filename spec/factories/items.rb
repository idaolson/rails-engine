FactoryBot.define do
  factory :item do
    association :merchant
    name { Faker::Movies::StarWars.planet }
    description { Faker::Movies::StarWars.quote }
    unit_price { Faker::Commerce.price }
  end
end
