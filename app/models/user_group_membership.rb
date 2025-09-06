# frozen_string_literal: true

# UserGroupMembership represents the relationship between users and user groups.
# This is a join table that allows users to be members of multiple groups.
#
# @example
#   membership = UserGroupMembership.create(user: user, user_group: group)
#
class UserGroupMembership < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :user_group

  # Validations
  validates :user, presence: true
  validates :user_group, presence: true
  validates :user_id, uniqueness: { scope: :user_group_id, message: 'is already a member of this group' }

  # Scopes
  scope :for_user, ->(user) { where(user: user) }
  scope :for_group, ->(group) { where(user_group: group) }
end
