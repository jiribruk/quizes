# frozen_string_literal: true

# EvaluateQuiz is a service object that compares a user's answers
# with the correct answers of a given quiz. It returns a hash
# mapping each question ID to a boolean indicating correctness.
class EvaluateQuiz
  include Callable

  def initialize(quiz, user_answers)
    @quiz = quiz
    @user_answers = user_answers
  end

  def call
    @results = []
    @quiz.questions.each do |question|
      @results << ::QuestionResult.new(question.id.to_s, question.correct_answer.id.to_s, @user_answers[question.id.to_s])
    end
    @results
  end
end
