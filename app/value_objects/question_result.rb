# frozen_string_literal: true

# Represents the result of answering a single question.
# It stores the question ID, the correct answer ID, and the user's selected answer ID.
# Provides a method to check whether the user's answer was correct.
#
# @example
#   result = QuestionResult.new(
#     question_id: 1,
#     correct_answer_id: 42,
#     user_answer_id: 42,
#     correct: true
#   )
#   result.correct? # => true
#
class QuestionResult
  # @return [String] the ID of the question
  attr_reader :question_id

  # @return [String] the ID of the correct answer
  attr_reader :correct_answer_id

  # @return [String, nil] the ID of the user's selected answer
  attr_reader :user_answer_id

  # @return [Boolean] true if the user's answer is correct, false otherwise
  attr_reader :correct

  # Initializes a new QuestionResult instance.
  #
  # @param question_id [String] the ID of the question
  # @param correct_answer_id [String] the ID of the correct answer
  # @param user_answer_id [String, nil] the ID of the user's selected answer
  # @param correct [Boolean] whether the user's answer is correct
  def initialize(question_id:, correct_answer_id:, user_answer_id:, correct:)
    @question_id = question_id
    @correct_answer_id = correct_answer_id
    @user_answer_id = user_answer_id
    @correct = correct
  end
end
