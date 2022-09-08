FactoryBot.define do
  factory :car do
    brand { association(:brand) }

    model { Faker::Vehicle.model }
  end
end
