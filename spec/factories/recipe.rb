FactoryBot.define do
  factory :recipe do
    name { Faker::Food.dish }
    people { 3 }
    preparation_time { '15 min' }
    cook_time { '10 min' }
    total_time { '25 min' }
    difficulty { 'easy' }
    rate { 5 }
  end
end
