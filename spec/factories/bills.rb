FactoryBot.define do
  factory :bill, class: 'Bill' do
    trait :cheap_bill do
      price_cents { 12700 }
      association :room, :small, strategy: :create
    end

    trait :average_bill do
      price_cents { 34500 }
      association :request, :average_request, strategy: :build_stubbed
      association :room, :medium, strategy: :build_stubbed
    end

    trait :expensive_bill do
      price_cents { 485000 }
      association :request, :most_expensive_request, strategy: :build_stubbed
      association :room, :large, strategy: :build_stubbed
    end

    user { build_stubbed(:user, :client) }
    request { build_stubbed(:request, :cheap_request) }
    room { build_stubbed(:room, :small) }
  end
end
