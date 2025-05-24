# frozen_string_literal: true

# QuizResult represents the result of a quiz evaluation, including the score and individual question results.
#
# @example
#   result = QuizResult.new
#   result.add_question_result(question_result)
#   result.increase_score
#   puts result.score
#   puts result.question_results
class QuizResult
  # @return [Integer] the score achieved in the quiz
  attr_reader :score

  # @return [Array] the results for each question
  attr_reader :question_results

  # @return [Integer] the number of questions in the quiz
  attr_reader :questions_count

  # Initializes a new QuizResult with zero score and empty question results.
  def initialize
    @score = 0
    @question_results = []
    @questions_count = 0
  end

  # Adds a question result to the list of question results.
  #
  # @param question_result [Object] the result of a single question
  # @return [void]
  def add_question_result(question_result:)
    @question_results << question_result
    @questions_count += 1
  end

  # Increases the score by 1.
  #
  # @return [void]
  def increase_score
    @score += 1
  end
end
