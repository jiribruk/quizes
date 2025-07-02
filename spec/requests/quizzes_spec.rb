# frozen_string_literal: true

require 'rails_helper'

describe 'Quizzes', type: :request do
  describe 'GET /quizzes' do
    subject(:request_response) do
      get quizzes_path
      response
    end

    context 'when the success' do
      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:index) }
    end
  end

  describe 'GET /quizzes/:id' do
    subject(:request_response) do
      get quiz_path(id: quiz_id)
      response
    end

    context 'when the quiz exists' do
      let(:quiz_id) { create(:quiz).id }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:show) }
    end

    context 'when the quiz does not exist' do
      let(:quiz_id) { 999 }

      it { is_expected.to have_http_status(:not_found) }
      it { is_expected.not_to render_template(:show) }
    end
  end

  describe 'GET /quizzes/new' do
    subject(:request_response) do
      get new_quiz_path
      response
    end

    context 'when the success' do
      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:new) }
    end
  end

  describe 'POST /quizzes' do
    subject(:request_response) do
      post quizzes_path, params: { quiz: quiz_params }
      response
    end

    context 'when the quiz params are valid' do
      let(:quiz_params) { { name: 'Test Quiz', category: 'Test Category' } }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(quiz_path(Quiz.last)) }

      it 'creates a new quiz' do
        expect { request_response }.to change(Quiz, :count).by(1)
      end

      it 'sets success flash message' do
        request_response
        expect(flash[:notice]).to eq(I18n.t('flash.messages.success'))
      end
    end

    context 'when the quiz params are invalid' do
      let(:quiz_params) { { name: '', category: 'Test Category' } }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(new_quiz_path) }

      it 'does not create a new quiz' do
        expect { request_response }.not_to change(Quiz, :count)
      end

      it 'sets alert flash message' do
        request_response
        expect(flash[:alert]).to include("Name can't be blank")
      end
    end
  end

  describe 'GET /quizzes/:id/edit' do
    subject(:request_response) do
      get edit_quiz_path(quiz)
      response
    end

    context 'when the quiz exists' do
      let(:quiz) { create(:quiz) }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:edit) }
    end

    context 'when the quiz does not exist' do
      let(:quiz) { double('quiz', id: 999) }

      it { is_expected.to have_http_status(:not_found) }
      it { is_expected.not_to render_template(:edit) }
    end
  end

  describe 'PATCH /quizzes/:id' do
    subject(:request_response) do
      patch quiz_path(quiz), params: { quiz: quiz_params }
      response
    end

    context 'when the quiz params are valid' do
      let(:quiz) { create(:quiz, name: 'Original Name') }
      let(:quiz_params) { { name: 'Updated Quiz Name', category: 'Updated Category' } }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(quiz_path(quiz)) }

      it 'updates the quiz' do
        request_response
        expect(quiz.reload.name).to eq('Updated Quiz Name')
      end

      it 'sets success flash message' do
        request_response
        expect(flash[:notice]).to eq(I18n.t('flash.messages.success'))
      end
    end

    context 'when the quiz params are invalid' do
      let(:quiz) { create(:quiz, name: 'Original Name') }
      let(:quiz_params) { { name: '', category: 'Updated Category' } }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(edit_quiz_path(quiz)) }

      it 'does not update the quiz' do
        request_response
        expect(quiz.reload.name).to eq('Original Name')
      end

      it 'sets alert flash message' do
        request_response
        expect(flash[:alert]).to include("Name can't be blank")
      end
    end
  end

  describe 'DELETE /quizzes/:id' do
    subject(:request_response) do
      delete quiz_path(quiz)
      response
    end

    context 'when the quiz exists' do
      let!(:quiz) { create(:quiz) }

      it { is_expected.to have_http_status(:redirect) }
      it { is_expected.to redirect_to(root_path) }

      it 'deletes the quiz' do
        expect { request_response }.to change(Quiz, :count).by(-1)
      end

      it 'sets success flash message' do
        request_response
        expect(flash[:notice]).to eq(I18n.t('flash.messages.success'))
      end
    end

    context 'when the quiz does not exist' do
      let(:quiz) { double('quiz', id: 999) }

      it { is_expected.to have_http_status(:not_found) }
    end
  end

  describe 'POST /quizzes/:id/evaluation' do
    let(:quiz) { create(:quiz, :with_questions_and_answers) }
    let(:question) { quiz.questions.first }
    let(:correct_answer) { question.correct_answer }
    let(:user_answers) { { question.id.to_s => correct_answer.id.to_s } }

    subject(:request_response) do
      post evaluation_quiz_path(quiz), params: { answers: user_answers }, as: :turbo_stream
      response
    end

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:evaluation) }
  end
end
