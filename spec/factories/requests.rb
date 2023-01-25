FactoryBot.define do
  factory :request, class: 'Request' do

    trait :cheap_request do
      places_amount { 1 }
      room_class { 0 }
      stay_time_from { DateTime.now + 5 }
      stay_time_to { DateTime.now + 6 }
      comment { 'With TV' }
    end

    trait :average_request do
      places_amount { 4 }
      room_class { 4 }
      stay_time_from { DateTime.now + 7 }
      stay_time_to { DateTime.now + 8 }
      comment { 'With 5 TVs' }
    end

    trait :expensive_request do
      places_amount { 8 }
      room_class { 7 }
      stay_time_from { DateTime.now + 9 }
      stay_time_to { DateTime.now + 10 }
      comment { 'With 20 TVs' }
    end

    trait :most_expensive_request do
      places_amount { 80 }
      room_class { 9 }
      stay_time_from { DateTime.now + 11 }
      stay_time_to { DateTime.now + 12 }
      comment { 'With 200 TVs' }
    end

    user { build_stubbed(:user, :client) }
  end
end
