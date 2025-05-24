# frozen_string_literal: true

require 'rails_helper'

describe 'Quizzes', type: :request do
  describe 'GET /quizzes' do
    it 'returns http success' do
      get quizzes_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /quizzes/:id' do
    subject { get quiz_path(id: quiz_id) }
    before(:each) { subject }

    context 'when the quiz exists' do
      let(:quiz_id) { create(:quiz).id }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
    end

    context 'when the quiz does not exist' do
      let(:quiz_id) { 999 }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response).not_to render_template(:show) }
    end
  end
end
