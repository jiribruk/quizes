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
    @quiz.questions.build
    @quiz.questions.first.answers.build
    @indexes = Indexes.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      flash[:notice] = t('flash.messages.success')
      redirect_to quiz_path(@quiz)
    else
      flash[:alert] = @quiz.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    quiz
  end

  def update
    quiz.attributes = quiz_params
    if quiz.save
      flash[:notice] = t('flash.messages.success')
      redirect_to quiz_path(quiz)
    else
      flash[:alert] = @quiz.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end
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

  def add_question
    @quiz = Quiz.new
    indexes.question_index_up
    @question = Question.new
    @question.answers.build

    respond_to(&:turbo_stream)
  end

  def add_answer
    @quiz = Quiz.new
    indexes.answer_index_up
    @answer = Answer.new

    respond_to(&:turbo_stream)
  end

  private

  # Finds the quiz by id param.
  # @return [Quiz]
  def quiz
    @quiz ||= Quiz.find(params[:id])
  end

  def indexes
    @indexes ||= Indexes.new(question_index: params[:question_index].to_i, answer_index: params[:answer_index].to_i)
  end

  def quiz_params
    params.require(:quiz).permit(
      :name,
      :category,
      questions_attributes: [
        :id,
        :image,
        :text,
        :_destroy,
        { answers_attributes: [
          :id,
          :text,
          :correct,
          :_destroy
        ] }
      ]
    )
  end
end
