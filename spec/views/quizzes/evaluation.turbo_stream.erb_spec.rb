# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/evaluation.turbo_stream', type: :view do
  subject(:rendered) { render }

  before { assign(:results, [question_result]) }

  context 'when the user answers are correct' do
    let(:question_result) do
      build_stubbed(:question_result,
                    question_id: 1,
                    correct_answer_id: 2,
                    user_answer_id: 2,
                    correct: true)
    end
    it { is_expected.to include('correct-icon') }
  end

  context 'when the user answers are incorrect' do
    let(:question_result) do
      build_stubbed(:question_result,
                    question_id: 2,
                    correct_answer_id: 3,
                    user_answer_id: 4,
                    correct: false)
    end
    it { is_expected.to include('incorrect-icon') }
  end
end
