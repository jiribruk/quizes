# frozen_string_literal: true

# User model with Devise authentication.
# Handles user registration, login, and authentication.
#
# @example
#   user = User.create(email: "user@example.com", password: "password123")
#   user.valid_password?("password123") # => true
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validates presence of email
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Returns user's display name (email for now)
  #
  # @return [String] the user's display name
  def display_name
    email
  end
end