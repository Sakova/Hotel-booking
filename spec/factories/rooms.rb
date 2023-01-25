FactoryBot.define do
  factory :room, class: 'Room' do
    trait :small do
      places_amount { 2 }
      room_class { 0 }
      room_number { generate :number }
      price { 24500 }
    end

    trait :medium do
      places_amount { 4 }
      room_class { 4 }
      room_number { generate :number }
      price { 50000 }
    end

    trait :large do
      places_amount { 8 }
      room_class { 7 }
      room_number { generate :number }
      price { 400000 }
    end
  end

  sequence(:number, 100) { |n| n }
end
