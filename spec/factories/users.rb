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

    # Trait for confirmed user
    trait :confirmed do
      confirmed_at { Time.current }
    end

    # Trait for admin user (if needed in future)
    trait :admin do
      sequence(:email) { |n| "admin#{n}@example.com" }
    end
  end
end
