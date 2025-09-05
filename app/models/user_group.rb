# frozen_string_literal: true

# UserGroup represents a group of users that can be invited to view private quizzes.
# Groups are created by users and can contain both existing and non-existing users.
#
# @example
#   group = UserGroup.create(name: "Team Alpha", description: "Development team", owner: current_user)
#   group.invite_user("user@example.com")
#
class UserGroup < ApplicationRecord
  # Associations
  belongs_to :owner, class_name: 'User'
  has_many :user_group_memberships, dependent: :destroy
  has_many :users, through: :user_group_memberships
  has_many :quiz_user_groups, dependent: :destroy
  has_many :quizzes, through: :quiz_user_groups

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :owner, presence: true

  # Scopes
  scope :owned_by, ->(user) { where(owner: user) }
  scope :with_member, ->(user) { joins(:users).where(users: { id: user.id }) }

  # Check if user is a member of this group
  #
  # @param user [User] the user to check
  # @return [Boolean] true if user is a member
  def member?(user)
    users.include?(user)
  end

  # Check if user is the owner of this group
  #
  # @param user [User] the user to check
  # @return [Boolean] true if user is the owner
  def owner?(user)
    owner == user
  end

  # Check if user can manage this group (owner or admin)
  #
  # @param user [User] the user to check
  # @return [Boolean] true if user can manage the group
  def manageable_by?(user)
    owner?(user)
  end

  # Add user to group
  #
  # @param user [User] the user to add
  # @return [UserGroupMembership] the created membership
  def add_member(user)
    user_group_memberships.find_or_create_by(user: user)
  end

  # Remove user from group
  #
  # @param user [User] the user to remove
  # @return [Boolean] true if user was removed
  def remove_member(user)
    user_group_memberships.where(user: user).destroy_all.any?
  end

  # Invite user by email (creates pending invitation)
  #
  # @param email [String] the email to invite
  # @return [UserGroupInvitation] the created invitation
  def invite_user(email)
    # This will be implemented when we add invitation system
    # For now, we'll just add existing users
    user = User.find_by(email: email)
    add_member(user) if user
  end
end
