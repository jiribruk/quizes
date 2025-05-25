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
