# frozen_string_literal: true

# EvaluateQuiz is a service object that compares a user's answers
# with the correct answers of a given quiz. It returns an array of QuestionResult objects
# for each question in the quiz, indicating the correctness of each answer.
#
# @example
#   results = EvaluateQuiz.call(quiz: quiz, user_answers: { '1' => '2', '2' => '4' })
#   results.each do |result|
#     puts result.correct? # => true or false
#   end
#
# @see QuestionResult
class EvaluateQuiz
  include Callable

  # Initializes the service with a quiz and user answers.
  #
  # @param quiz [Quiz] The quiz to be evaluated.
  # @param user_answers [Hash{String => String}] A hash mapping question IDs to user answer IDs.
  def initialize(quiz:, user_answers:)
    @quiz = quiz
    @user_answers = user_answers
  end

  # Evaluates the quiz and returns an array of QuestionResult objects.
  #
  # @return [Array<QuestionResult>] The evaluation results for each question.
  def call
    result = QuizResult.new
    @quiz.questions.each do |question|
      add_question_result(question, result)
      result.increase_score if correct?(question)
    end
    result
  end

  private

  # Returns the correct answer ID for a question as a string.
  #
  # @param question [Question]
  # @return [String] The correct answer ID.
  def correct_answer_id(question)
    question.correct_answer.id.to_s
  end

  # Returns the user answer ID for a question as a string.
  #
  # @param question [Question]
  # @return [String, nil] The user's answer ID or nil if not answered.
  def user_answer_id(question)
    @user_answers[question.id.to_s]
  end

  # Determines if the user's answer is correct for a given question.
  #
  # @param question [Question]
  # @return [Boolean] True if the user's answer matches the correct answer.
  def correct?(question)
    correct_answer_id(question) == user_answer_id(question)
  end

  def add_question_result(question, result)
    result.add_question_result(
      question_id: question.id.to_s,
      correct_answer_id: correct_answer_id(question),
      user_answer_id: user_answer_id(question),
      correct: correct?(question)
    )
  end
end
