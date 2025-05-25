# frozen_string_literal: true

require 'rails_helper'

describe QuizzesHelper, type: :helper do
  describe '#quizzes_list_item' do
    let(:quiz) { create(:quiz, name: 'Sample Quiz') }
    subject(:item) { quizzes_list_item(quiz:) }

    it { is_expected.to have_selector('li.list-group-item.w-50.mx-auto.rounded') }
    it { is_expected.to have_link('Sample Quiz', href: quiz_path(quiz)) }
  end

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

  describe '#quizzes_group_header' do
    subject(:header_html) { quizzes_group_header(category_label: 'movies') }

    it { is_expected.to have_selector('li.list-unstyled.fw-bold.text-uppercase.mb-1.w-50.mx-auto') }
    it { is_expected.to have_selector('h5', text: I18n.t('quiz.category.movies')) }
  end
end
