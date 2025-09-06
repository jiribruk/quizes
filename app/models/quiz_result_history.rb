# frozen_string_literal: true

# QuizResultHistory represents a user's attempt at completing a quiz.
# Stores the score, questions count, and completion timestamp for history tracking.
#
# @example
#   history = QuizResultHistory.create(
#     user: user,
#     quiz: quiz,
#     score: 3,
#     questions_count: 5,
#     completed_at: Time.current
#   )
#   history.percentage # => 60.0
#   history.performance_level # => :yellow
#
class QuizResultHistory < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  # Validations
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :questions_count, presence: true, numericality: { greater_than: 0 }
  validates :completed_at, presence: true
  validates :score, numericality: { less_than_or_equal_to: :questions_count }

  # Scopes
  scope :recent, -> { order(completed_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }
  scope :for_quiz, ->(quiz) { where(quiz: quiz) }

  # Returns the percentage score for this attempt
  #
  # @return [Float] percentage score (0.0 to 100.0)
  def percentage
    return 0.0 if questions_count.zero?

    (score.to_f / questions_count * 100).round(1)
  end

  # Returns the performance level based on percentage score
  #
  # @return [Symbol] :green, :yellow, :red
  def performance_level
    case percentage
    when 75.0..100.0
      :green
    when 40.0...75.0
      :yellow
    else
      :red
    end
  end

  # Returns the best score for this user and quiz combination
  # Orders by calculated percentage (score/questions_count) descending
  #
  # @return [QuizResultHistory, nil] the best attempt or nil if none exist
  def self.best_for_user_and_quiz(user:, quiz:)
    for_user(user).for_quiz(quiz)
                  .order(Arel.sql('(score * 100.0 / questions_count) DESC'))
                  .first
  end

  # Returns the latest attempt for this user and quiz combination
  #
  # @return [QuizResultHistory, nil] the latest attempt or nil if none exist
  def self.latest_for_user_and_quiz(user:, quiz:)
    for_user(user).for_quiz(quiz).recent.first
  end
end
