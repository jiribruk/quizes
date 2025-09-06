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
  has_many :quiz_result_histories, dependent: :destroy

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

  # Returns the best result history for a specific user
  #
  # @param user [User] the user to get best result for
  # @return [QuizResultHistory, nil] the best attempt or nil if none exist
  def best_result_for_user(user)
    QuizResultHistory.best_for_user_and_quiz(user: user, quiz: self)
  end

  # Returns the latest result history for a specific user
  #
  # @param user [User] the user to get latest result for
  # @return [QuizResultHistory, nil] the latest attempt or nil if none exist
  def latest_result_for_user(user)
    QuizResultHistory.latest_for_user_and_quiz(user: user, quiz: self)
  end

  # Returns the performance level for a specific user based on their best result
  #
  # @param user [User] the user to get performance level for
  # @return [Symbol, nil] :green, :yellow, :red, or nil if no attempts
  def performance_level_for_user(user)
    best_result = best_result_for_user(user)
    best_result&.performance_level
  end
end
