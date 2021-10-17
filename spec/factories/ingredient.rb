FactoryBot.define do
  factory :ingredient do
    name { "#{Faker::Food.measurement} of #{Faker::Food.ingredient}" }
  end
end
