# frozen_string_literal: true

# Represents the result of answering a single question.
# It stores the question ID, the correct answer ID, and the user's selected answer ID.
# Provides a method to check whether the user's answer was correct.
#
# @example
#   result = QuestionResult.new(1, 42, 42)
#   result.correct? # => true
#
class QuestionResult
  # @return [Integer] the ID of the question
  attr_reader :question_id

  # @return [Integer] the ID of the correct answer
  attr_reader :correct_answer_id

  # @return [Integer, nil] the ID of the user's selected answer
  attr_reader :user_answer_id

  # Initializes a new QuestionResult instance.
  #
  # @param question_id [Integer] the ID of the question
  # @param correct_answer_id [Integer] the ID of the correct answer
  # @param user_answer_id [Integer, nil] the ID of the user's selected answer
  def initialize(question_id, correct_answer_id, user_answer_id)
    @question_id = question_id
    @correct_answer_id = correct_answer_id
    @user_answer_id = user_answer_id
  end

  # Determines whether the user's answer is correct.
  #
  # @return [Boolean] true if the user's answer matches the correct answer, false otherwise
  def correct?
    correct_answer_id == user_answer_id
  end
end
