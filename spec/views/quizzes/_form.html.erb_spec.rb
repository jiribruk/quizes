# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/_form', type: :view do
  let(:quiz) { build_stubbed(:quiz, questions: [question]) }
  let(:question) { build_stubbed(:question, text: 'Question text') }
  let(:indexes) { Indexes.new(question_index: 1, answer_index: 3) }

  before do
    assign(:indexes, indexes)
  end

  subject(:rendered) { render partial: 'quizzes/form', locals: { quiz: quiz } }

  it { is_expected.to have_selector("form[action='#{quiz_path(quiz)}']") }
  it { is_expected.to have_selector("form[method='post']") }
  it { is_expected.to have_selector('form[enctype="multipart/form-data"]') }

  it { is_expected.to have_selector("input[type='text'][name='quiz[name]']") }
  it { is_expected.to have_selector("input[type='text'][name='quiz[category]']") }

  it { is_expected.to have_selector('label', text: I18n.t('labels.quiz_name')) }
  it { is_expected.to have_selector('label', text: I18n.t('labels.category')) }

  it { is_expected.to have_content(I18n.t('titles.quiz_form')) }
  it { is_expected.to have_content(I18n.t('titles.questions_section')) }

  it 'renders the question partial for each question' do
    expect(view).to render_template(partial: 'quizzes/_question_form')
  end

  it { is_expected.to have_selector("a#add_question_button.btn.btn-success.btn-sm") }
  it { is_expected.to have_link(I18n.t('buttons.add_question'), href: add_question_quizzes_path(question_index: indexes.question_index)) }

  it { is_expected.to have_selector("input[type='submit']") }
end
