# frozen_string_literal: true

# Quiz represents a quiz entity with associated questions.
# Supports nested attributes for creating/updating questions and answers.
#
# @example
#   quiz = Quiz.new(name: "Math Quiz", category: "Mathematics")
#   quiz.questions.build(text: "What is 2+2?")
#   quiz.save
#
class Quiz < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  has_many :questions, inverse_of: :quiz, dependent: :destroy
  has_many :quiz_user_groups, dependent: :destroy
  has_many :user_groups, through: :quiz_user_groups

  # Enums
  attribute :visibility, :integer
  enum :visibility, { private: 0, public: 1 }, prefix: true

  # Validations
  validates :name, presence: true
  validates :user, presence: true, if: :visibility_private?

  # Scopes
  scope :visible_to_user, lambda { |user|
    includes(:user_groups)
      .where(visibility: 'public')
      .or(where(visibility: 'private', user: user))
      .or(where(visibility: 'private', user_groups: { id: user.user_groups.pluck(:id) }))
  }

  # Orders quizzes by name in ascending order
  default_scope { order(name: :asc) }

  # Allows nested attributes for questions, including destroy functionality
  accepts_nested_attributes_for :questions, allow_destroy: true

  # Check if quiz is visible to a specific user
  #
  # @param user [User] the user to check visibility for
  # @return [Boolean] true if user can see this quiz
  def visible_to?(user)
    return true if visibility_public?
    return true if visibility_private? && user == self.user
    return true if visibility_private? && user&.user_groups&.exists?(id: user_groups.pluck(:id))

    false
  end
end
