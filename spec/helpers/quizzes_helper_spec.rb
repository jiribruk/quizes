# frozen_string_literal: true

require 'rails_helper'

describe QuizzesHelper, type: :helper do
  describe '#quiz_question_title' do
    subject(:title_html) { quiz_question_title(question_text: 'What is Ruby?') }

    it { is_expected.to have_selector('h4', text: 'What is Ruby?') }
  end

  describe '#score_title' do
    let(:score) { 3 }
    let(:questions_count) { 5 }
    subject(:score_html) { score_title(score:, questions_count:) }

    it do
      is_expected.to have_selector('h1#score_title.animated_score_title.mb-4.w-50.mx-auto',
                                   text: I18n.t('quiz.score', score:, questions_count:))
    end
  end
end
