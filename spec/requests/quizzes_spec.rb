# frozen_string_literal: true

require 'rails_helper'

# Request specs for QuizzesController covering all CRUD operations
# and dynamic form functionality with Turbo Streams
#
# @see QuizzesController
describe 'Quizzes', type: :request do
  # GET /quizzes
  # Tests the index action that displays all quizzes grouped by category
  describe 'GET /quizzes' do
    it 'renders index' do
      get quizzes_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

  # GET /quizzes/:id
  # Tests the show action that displays a specific quiz with its questions and answers
  describe 'GET /quizzes/:id' do
    context 'when quiz exists' do
      let(:quiz) { create(:quiz) }

      it 'renders show' do
        get quiz_path(quiz)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
    end

    context 'when quiz does not exist' do
      it 'returns 404' do
        get quiz_path(id: 999_999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # GET /quizzes/new
  # Tests the new action that displays form for creating a new quiz
  describe 'GET /quizzes/new' do
    it 'renders new' do
      get new_quiz_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  # POST /quizzes
  # Tests the create action with nested attributes for questions and answers
  describe 'POST /quizzes' do
    context 'with valid params' do
      let(:quiz_params) do
        {
          name: 'Valid Quiz',
          category: 'Science',
          questions_attributes: {
            '0' => {
              text: 'What is Ruby?',
              answers_attributes: {
                '0' => { text: 'A gemstone', correct: false },
                '1' => { text: 'A programming language', correct: true }
              }
            }
          }
        }
      end

      it 'creates quiz and redirects' do
        expect do
          post quizzes_path, params: { quiz: quiz_params }
        end.to change(Quiz, :count).by(1)

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(I18n.t('flash.messages.success'))
      end
    end

    context 'with invalid params' do
      let(:quiz_params) { { name: '', category: '' } }

      it 'does not create quiz and renders new' do
        expect do
          post quizzes_path, params: { quiz: quiz_params }
        end.not_to change(Quiz, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  # GET /quizzes/:id/edit
  # Tests the edit action that displays form for editing an existing quiz
  describe 'GET /quizzes/:id/edit' do
    let(:quiz) { create(:quiz) }

    it 'renders edit' do
      get edit_quiz_path(quiz)
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end

  # PATCH /quizzes/:id
  # Tests the update action with nested attributes and image handling
  describe 'PATCH /quizzes/:id' do
    let!(:quiz) { create(:quiz, name: 'Original') }

    context 'with valid params' do
      it 'updates and redirects' do
        patch quiz_path(quiz), params: { quiz: { name: 'Updated' } }
        expect(response).to redirect_to(quiz_path(quiz))
        expect(quiz.reload.name).to eq('Updated')
        expect(flash[:notice]).to eq(I18n.t('flash.messages.success'))
      end
    end

    context 'with invalid params' do
      it 'does not update and renders edit' do
        patch quiz_path(quiz), params: { quiz: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to be_present
        expect(quiz.reload.name).to eq('Original')
      end
    end
  end

  # DELETE /quizzes/:id
  # Tests the destroy action that deletes a quiz and all its associations
  describe 'DELETE /quizzes/:id' do
    let!(:quiz) { create(:quiz) }

    it 'deletes quiz and redirects' do
      expect do
        delete quiz_path(quiz)
      end.to change(Quiz, :count).by(-1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq(I18n.t('flash.messages.success'))
    end
  end

  # POST /quizzes/:id/evaluation
  # Tests the evaluation action that evaluates user answers against the quiz
  describe 'POST /quizzes/:id/evaluation' do
    let(:quiz) { create(:quiz, :with_questions_and_answers) }
    let(:question) { quiz.questions.first }
    let(:correct_answer) { question.correct_answer }
    let(:user_answers) { { question.id.to_s => correct_answer.id.to_s } }

    it 'evaluates quiz and renders turbo stream' do
      post evaluation_quiz_path(quiz), params: { answers: user_answers }, as: :turbo_stream
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:evaluation)
    end
  end

  # POST /quizzes/add_question
  # Tests the add_question action that adds a new question form dynamically
  describe 'POST /quizzes/add_question' do
    it 'returns turbo stream response' do
      post add_question_quizzes_path(question_index: 0, answer_index: 0), as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end

  # POST /quizzes/add_answer
  # Tests the add_answer action that adds a new answer form dynamically
  describe 'POST /quizzes/add_answer' do
    it 'returns turbo stream response' do
      post add_answer_quizzes_path(question_index: 0, answer_index: 0), as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end
end
