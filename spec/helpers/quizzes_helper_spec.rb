# frozen_string_literal: true

require 'rails_helper'

describe QuizzesHelper, type: :helper do
  describe '#quizzes_list' do
    let(:quiz1) { create(:quiz, name: 'Quiz 1') }
    let(:quiz2) { create(:quiz, name: 'Quiz 2') }
    let(:quizzes) { [quiz1, quiz2] }
    subject(:list_html) { quizzes_list(quizzes) }

    it { is_expected.to have_selector('ul.list-group') }
    it { is_expected.to have_selector('li.list-group-item.w-50.mx-auto.rounded', count: 2) }
    it { is_expected.to have_link('Quiz 1', href: quiz_path(quiz1)) }
    it { is_expected.to have_link('Quiz 2', href: quiz_path(quiz2)) }
  end

  describe '#quizzes_list_item' do
    let(:quiz) { create(:quiz, name: 'Sample Quiz') }
    subject(:item) { quizzes_list_item(quiz) }

    it { is_expected.to have_selector('li.list-group-item.w-50.mx-auto.rounded') }
    it { is_expected.to have_link('Sample Quiz', href: quiz_path(quiz)) }
  end

  describe '#quiz_question_title' do
    subject(:title_html) { quiz_question_title('What is Ruby?') }

    it { is_expected.to have_selector('h4', text: 'What is Ruby?') }
  end

  describe '#quiz_answer_item' do
    let(:question) { build_stubbed(:question, id: 1) }
    let(:answer) { build_stubbed(:answer, id: 2, text: '42') }

    subject(:html_answer_item) { quiz_answer_item(question, answer, spy) }

    it { is_expected.to have_selector('li.list-group-item.w-25.mx-auto.rounded.d-flex.justify-content-between') }
  end
end
