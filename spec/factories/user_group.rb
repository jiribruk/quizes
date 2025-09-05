# frozen_string_literal: true

# Factory for creating UserGroup instances
# Provides traits for creating user groups with various configurations
#
# @example
#   create(:user_group) # Creates a basic user group
#   create(:user_group, :with_members) # Creates a user group with members
#
FactoryBot.define do
  factory :user_group do
    sequence(:name) { |n| "User Group #{n}" }
    sequence(:description) { |n| "Description for user group #{n}" }
    association :owner, factory: :user

    # Trait for creating a user group with members
    trait :with_members do
      after(:create) do |user_group|
        create_list(:user_group_membership, 3, user_group: user_group)
      end
    end
  end
end
