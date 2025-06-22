# frozen_string_literal: true

# QuizzesController handles displaying and showing quizzes.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class QuizzesController < ApplicationController
  # GET /quizzes
  def index
    @grouped_quizzes = Quiz.all.group_by(&:category)

    respond_to(&:html)
  end

  # GET /quizzes/:id
  def show
    quiz

    respond_to(&:html)
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      flash[:notice] = t('flash.messages.success')
    else
      flash[:alert] = t('flash.messages.failed')
    end
    redirect_to root_path
  end

  def edit
    quiz
  end

  def update
    quiz.attributes = quiz_params
    if quiz.save
      flash[:notice] = t('flash.messages.success')
    else
      flash[:alert] = t('flash.messages.failed')
    end
    redirect_to root_path
  end

  def destroy
    quiz.destroy
    flash[:notice] = t('flash.messages.success')
    redirect_to root_path
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

  def quiz_params
    params.require(:quiz).permit(:name, :category)
  end
end
