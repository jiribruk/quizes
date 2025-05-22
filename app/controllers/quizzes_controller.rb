# frozen_string_literal: true

# QuizzesController handles displaying and showing quizzes.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class QuizzesController < ApplicationController
  # GET /quizzes
  def index
    @quizzes = Quiz.all

    respond_to do |format|
      format.html #index.html.erb
    end
  end

  # GET /quizzes/:id
  def show
    quiz

    respond_to do |format|
      format.html #show.html.erb
    end
  end

  def evaluation

    @result = EvaluateQuiz.call(quiz, params[:answers])

    respond_to do |format|
      format.turbo_stream #evaluation.js.erb
    end
  end

  private

  # Finds the quiz by id param.
  # @return [Quiz]
  def quiz
    @quiz ||= Quiz.find(params[:id])
  end
end
