# frozen_string_literal: true

# QuizzesController handles CRUD operations for quizzes including nested questions and answers.
# Supports dynamic form management with Turbo Streams for adding/removing questions and answers.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class QuizzesController < ApplicationController
  before_action :authorize_quiz_access, only: [:show, :edit, :update, :destroy, :evaluation]
  before_action :authorize_quiz_ownership, only: [:edit, :update, :destroy]

  # GET /quizzes
  # Displays all quizzes visible to current user grouped by category
  #
  # @return [void]
  def index
    @grouped_quizzes = Quiz.visible_to_user(current_user).group_by(&:category)
    @user_groups = current_user.user_groups

    respond_to(&:html)
  end

  # GET /quizzes/:id
  # Displays a specific quiz with its questions and answers
  #
  # @return [void]
  def show
    quiz
    respond_to(&:html)
  end

  # GET /quizzes/new
  # Displays form for creating a new quiz with initial question and answer
  #
  # @return [void]
  def new
    @quiz = current_user.quizzes.build
    @quiz.questions.build
    @quiz.questions.first.answers.build
    @indexes = Indexes.new
    @user_groups = current_user.user_groups
  end

  # POST /quizzes
  # Creates a new quiz with nested questions and answers
  #
  # @return [void]
  def create
    @quiz = current_user.quizzes.build(quiz_params)
    if @quiz.save
      flash[:notice] = t('flash.messages.success')
      redirect_to quiz_path(@quiz)
    else
      @user_groups = current_user.user_groups
      flash[:alert] = @quiz.errors.full_messages.join(', ')
      render :new, status: :unprocessable_content
    end
  end

  # GET /quizzes/:id/edit
  # Displays form for editing an existing quiz
  #
  # @return [void]
  def edit
    quiz
  end

  # PATCH/PUT /quizzes/:id
  # Updates an existing quiz with nested questions and answers
  # Handles image removal from questions if requested
  #
  # @return [void]
  def update
    remove_image_from_question
    if quiz.update(quiz_params)
      flash[:notice] = t('flash.messages.success')
      redirect_to quiz_path(quiz)
    else
      flash[:alert] = quiz.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /quizzes/:id
  # Deletes a quiz and all its associated questions and answers
  #
  # @return [void]
  def destroy
    quiz.destroy
    flash[:notice] = t('flash.messages.success')
    redirect_to root_path
  end

  # POST /quizzes/:id/evaluation
  # Evaluates user answers against the quiz and returns results via Turbo Stream
  #
  # @return [void]
  def evaluation
    @result = EvaluateQuiz.call(quiz: quiz, user_answers: params[:answers], user: current_user)

    respond_to(&:turbo_stream)
  end

  # POST /quizzes/add_question
  # Adds a new question form dynamically via Turbo Stream
  #
  # @return [void]
  def add_question
    @quiz = Quiz.new
    indexes.question_index_up
    @question = Question.new
    @question.answers.build

    respond_to(&:turbo_stream)
  end

  # POST /quizzes/add_answer
  # Adds a new answer form dynamically via Turbo Stream
  #
  # @return [void]
  def add_answer
    @quiz = Quiz.new
    indexes.answer_index_up
    @answer = Answer.new

    respond_to(&:turbo_stream)
  end

  private

  # Finds the quiz by id param.
  #
  # @return [Quiz] the quiz instance
  def quiz
    @quiz ||= Quiz.find(params[:id])
  end

  # Authorizes access to quiz based on visibility rules
  #
  # @return [void]
  def authorize_quiz_access
    return if quiz.visible_to?(current_user)

    flash[:alert] = t('quiz.errors.access_denied')
    redirect_to quizzes_path
  end

  # Authorizes quiz ownership for edit/update/destroy actions
  #
  # @return [void]
  def authorize_quiz_ownership
    return if quiz.user == current_user

    flash[:alert] = t('quiz.errors.ownership_required')
    redirect_to quiz_path(quiz)
  end

  # Creates or retrieves Indexes instance for managing form indexes
  #
  # @return [Indexes] the indexes instance
  def indexes
    @indexes ||= Indexes.new(question_index: params[:question_index].to_i, answer_index: params[:answer_index].to_i)
  end

  # Strong parameters for quiz creation and updates
  # Permits nested attributes for questions and answers
  #
  # @return [ActionController::Parameters] permitted parameters
  def quiz_params
    params.require(:quiz).permit(
      :name,
      :category,
      :visibility,
      user_group_ids: [],
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

  # Removes images from questions when image_attachment_attributes[:_destroy] is set to '1'
  #
  # @return [void]
  def remove_image_from_question
    return unless params[:quiz][:questions_attributes]

    params[:quiz][:questions_attributes].each_value do |question_attrs|
      next unless question_attrs[:image_attachment_attributes]&.dig(:_destroy) == '1'

      question = Question.find(question_attrs[:id])
      question.image.purge if question.image.attached?
      question_attrs.delete(:image_attachment_attributes)
    end
  end
end
