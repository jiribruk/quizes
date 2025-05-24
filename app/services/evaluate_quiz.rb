# frozen_string_literal: true

# EvaluateQuiz is a service object that compares a user's answers
# with the correct answers of a given quiz. It returns a hash
# mapping each question ID to a boolean indicating correctness.
class EvaluateQuiz
  include Callable

  def initialize(quiz:, user_answers:)
    @quiz = quiz
    @user_answers = user_answers
  end

  def call
    @results = []
    @quiz.questions.each do |question|
      @results << ::QuestionResult.new(question_id: question.id,
                                       correct_answer_id: question.correct_answer.id,
                                       user_answer_id: @user_answers[question.id.to_s])
    end
    @results
  end
end
