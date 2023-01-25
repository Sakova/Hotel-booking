FactoryBot.define do
  factory :user, class: 'User' do
    trait :client do
      sequence(:email) { |n| "client_test#{n}.test.com" }
      name { 'User' }
    end

    trait :admin do
      name { 'Admin' }
      role { 'admin' }
      email { 'admin_test@test.com' }
    end

    password { BCrypt::Password.create('123123', const: 1) }

    factory :user_with_bills do
      transient do
        bills_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:second_bill, evaluator.bills_count, user: user)

        user.reload
      end
    end
  end
end
