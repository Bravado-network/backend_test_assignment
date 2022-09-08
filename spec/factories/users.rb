FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    preferred_price_range { [rand(1_000..10_000)...rand(11_000..50_000)] }
  end
end
