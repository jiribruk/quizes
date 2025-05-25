# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/evaluation.turbo_stream', type: :view do
  let(:quiz_result) do
    result = QuizResult.new
    result.add_question_result(question_result: question_result_positive)
    result.add_question_result(question_result: question_result_negative)
    result
  end

  let(:question_result_positive) do
    build(:question_result,
          question_id: 1,
          correct_answer_id: 2,
          user_answer_id: 2,
          correct: true)
  end
  let(:question_result_negative) do
    build(:question_result,
          question_id: 2,
          correct_answer_id: 3,
          user_answer_id: 4,
          correct: false)
  end

  subject(:rendered) { render }

  before { assign(:result, quiz_result) }

  it { is_expected.to include('turbo-stream action="replace" target="score_marker"') }
  it { is_expected.to include('turbo-stream action="update" target="answer_2_marker"') }
  it { is_expected.to include('✅') }
  it { is_expected.to include('turbo-stream action="update" target="answer_4_marker"') }
  it { is_expected.to include('❌') }
  it { is_expected.to include('turbo-stream action="remove" target="submit_button"') }
  it { is_expected.to match(%r{<h1[^>]*>#{I18n.t('quiz.score', score: quiz_result.score, questions_count: quiz_result.questions_count)}</h1>}) }
end
