# frozen_string_literal: true

require 'rails_helper'

describe 'Quizzes', type: :request do
  describe 'GET /quizzes' do
    let!(:request) { get quizzes_path }
    subject { response }

    context 'when the success' do
      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template(:index) }
    end
  end

  describe 'GET /quizzes/:id' do
    let!(:request) { get quiz_path(id: quiz_id) }
    subject { response }

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
end
