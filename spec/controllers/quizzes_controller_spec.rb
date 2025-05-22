# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let!(:quiz) { create(:quiz) }

  describe 'GET #index' do
    subject { get :index }

    it { is_expected.to be_successful }
  end

  describe 'GET #show' do
    subject { get :show, params: { id: quiz_id } }
    context 'when the quiz exists' do
      let(:quiz_id) { quiz.id }

      it { is_expected.to be_successful }
    end

    context 'when the quiz does not exist' do
      let(:quiz_id) { 999 }

      it { expect(subject.status).to eq(404) }
    end
  end
end
