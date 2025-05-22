# frozen_string_literal: true
class EvaluateQuiz
  include Callable

  def initialize(quiz, user_answers)
    @quiz = quiz
    @user_answers = user_answers
  end

  def call
    @result = {}
    @quiz.questions.each do |question|
      if @user_answers[question.id.to_s] == question.correct_answer.id.to_s
        @result[question.id.to_s] = true
      else
        @result[question.id.to_s] = false
      end
    end
    @result
  end

  private

end
