FactoryBot.define do
  factory :brand do
    name { Faker::Vehicle.manufacture }
  end
end
