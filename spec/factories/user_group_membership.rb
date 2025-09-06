# frozen_string_literal: true

# Factory for creating UserGroupMembership instances
# Represents the join table between users and user groups
#
# @example
#   create(:user_group_membership) # Creates a basic membership
#
FactoryBot.define do
  factory :user_group_membership do
    association :user, factory: :user
    association :user_group, factory: :user_group
  end
end
