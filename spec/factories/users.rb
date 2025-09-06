# frozen_string_literal: true

# Factory for creating User instances with Devise authentication
#
# @example
#   user = create(:user)
#   user_with_email = create(:user, email: "test@example.com")
#
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    first_name { 'Test' }
    last_name { 'User' }

    # Trait for confirmed user
    trait :confirmed do
      confirmed_at { Time.current }
    end

    # Trait for admin user (if needed in future)
    trait :admin do
      sequence(:email) { |n| "admin#{n}@example.com" }
      first_name { 'Admin' }
      last_name { 'User' }
    end

    # Trait for user without names (legacy)
    trait :without_names do
      first_name { nil }
      last_name { nil }
    end
  end
end
