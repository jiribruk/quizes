# QuizzesController handles displaying and showing quizzes.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class QuizzesController < ApplicationController

  # GET /quizzes
  def index
    @quizzes = Quiz.all
  end

  # GET /quizzes/:id
  def show
    quiz
  end

  private

  # Finds the quiz by id param.
  # @return [Quiz]
  def quiz
    @quiz ||= Quiz.find(params[:id])
  end

end
