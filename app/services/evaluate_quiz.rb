# frozen_string_literal: true

# EvaluateQuiz is a service object that compares a user's answers
# with the correct answers of a given quiz. It returns a QuizResult object
# containing the score and detailed results for each question.
#
# @example
#   result = EvaluateQuiz.call(quiz: quiz, user_answers: { '1' => '2', '2' => '4' })
#   result.score # => 1
#   result.question_results.each do |q_result|
#     puts q_result[:question_id], q_result[:correct], q_result[:user_answer_id]
#   end
#
# @see QuizResult
class EvaluateQuiz
  include Callable

  # Initializes the service with a quiz, user answers, and optionally a user.
  #
  # @param quiz [Quiz] The quiz to be evaluated.
  # @param user_answers [Hash{String => String}] A hash mapping question IDs to user answer IDs.
  # @param user [User] The user taking the quiz (optional, for history tracking).
  def initialize(quiz:, user_answers:, user:)
    @quiz = quiz
    @user_answers = user_answers || {}
    @user = user
  end

  # Evaluates the quiz and returns a QuizResult object with score and question results.
  # Also saves the result to history if a user is provided.
  #
  # @return [QuizResult] The evaluation result for the quiz.
  def call
    result = QuizResult.new
    @quiz.questions.each do |question|
      add_question_data_to_result(question:, result:)
      result.increase_score if correct?(question:)
    end

    # Save to history if user is provided
    save_to_history(result)

    result
  end

  private

  # Returns the correct answer ID for a question as a string.
  #
  # @param question [Question]
  # @return [String] The correct answer ID.
  def correct_answer_id(question:)
    question.correct_answer.id.to_s
  end

  # Returns the user answer ID for a question as a string.
  #
  # @param question [Question]
  # @return [String, nil] The user's answer ID or nil if not answered.
  def user_answer_id(question:)
    @user_answers[question.id.to_s]
  end

  # Determines if the user's answer is correct for a given question.
  #
  # @param question [Question]
  # @return [Boolean] True if the user's answer matches the correct answer.
  def correct?(question:)
    correct_answer_id(question:) == user_answer_id(question:)
  end

  # Adds the result for a single question to the QuizResult object.
  #
  # @param question [Question] The question being evaluated.
  # @param result [QuizResult] The result object to which the question result will be added.
  # @return [void]
  def add_question_data_to_result(question:, result:)
    result.add_question_result(question_result:
    QuestionResult.new(
      question_id: question.id.to_s,
      correct_answer_id: correct_answer_id(question:),
      user_answer_id: user_answer_id(question:),
      correct: correct?(question:)
    ))
  end

  # Saves the quiz result to the user's history
  #
  # @param result [QuizResult] The evaluation result to save
  # @return [void]
  def save_to_history(result)
    QuizResultHistory.create!(
      user: @user,
      quiz: @quiz,
      score: result.score,
      questions_count: result.questions_count,
      completed_at: Time.current
    )
  end
end
