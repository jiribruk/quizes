# frozen_string_literal: true

# QuizzesController handles displaying and showing quizzes.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class QuizzesController < ApplicationController
  # GET /quizzes
  def index
    @quizzes = Quiz.all

    respond_to(&:html)
  end

  # GET /quizzes/:id
  def show
    quiz

    respond_to(&:html)
  end

  def evaluation
    @result = EvaluateQuiz.call(quiz:, user_answers: params[:answers])

    respond_to(&:turbo_stream)
  end

  private

  # Finds the quiz by id param.
  # @return [Quiz]
  def quiz
    @quiz ||= Quiz.find(params[:id])
  end
end
