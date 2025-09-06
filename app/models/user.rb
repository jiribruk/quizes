# frozen_string_literal: true

# User model with Devise authentication.
# Handles user registration, login, authentication, and profile management.
#
# @example
#   user = User.create(email: "user@example.com", password: "password123", first_name: "John", last_name: "Doe")
#   user.valid_password?("password123") # => true
#   user.display_name # => "John Doe"
#   user.gravatar_url # => "https://www.gravatar.com/avatar/..."
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :quizzes, dependent: :destroy # TODO: optimalizovat pro skupinove kvízy
  has_many :owned_user_groups, class_name: 'UserGroup', foreign_key: 'owner_id', dependent: :destroy
  has_many :user_group_memberships, dependent: :destroy
  has_many :user_groups, through: :user_group_memberships
  has_many :quiz_result_histories, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validates :last_name, length: { minimum: 2, maximum: 50 }, allow_blank: true

  # Returns user's full display name
  #
  # @return [String] the user's full name or email if names are not set
  def display_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  # Returns Gravatar URL for the user
  #
  # @param size [Integer] the size of the avatar in pixels (default: 80)
  # @return [String] the Gravatar URL
  def gravatar_url(size: 80)
    require 'digest/md5'
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon"
  end
end
