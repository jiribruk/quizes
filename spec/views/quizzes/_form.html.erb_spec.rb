# frozen_string_literal: true

require 'rails_helper'

# View specs for quiz form partial
# Tests the form for creating and editing quizzes with nested questions and answers
#
# @see QuizzesController#new, QuizzesController#edit
describe 'quizzes/_form', type: :view do
  # Creates test quiz with question using build_stubbed for performance
  let(:quiz) { build_stubbed(:quiz, questions: [question]) }
  let(:question) { build_stubbed(:question, text: 'Question text') }
  let(:indexes) { Indexes.new(question_index: 1, answer_index: 3) }

  # Assigns indexes to the view instance variable
  before do
    assign(:indexes, indexes)
  end

  # Subject for testing the rendered form partial
  subject(:rendered) { render partial: 'quizzes/form', locals: { quiz: quiz } }

  # Tests that the form has correct action, method, and enctype attributes
  it { is_expected.to have_selector("form[action='#{quiz_path(quiz)}']") }
  it { is_expected.to have_selector("form[method='post']") }
  it { is_expected.to have_selector('form[enctype="multipart/form-data"]') }

  # Tests that quiz name and category input fields are present
  it { is_expected.to have_selector("input[type='text'][name='quiz[name]']") }
  it { is_expected.to have_selector("input[type='text'][name='quiz[category]']") }

  # Tests that form labels are displayed correctly
  it { is_expected.to have_selector('label', text: I18n.t('labels.quiz_name')) }
  it { is_expected.to have_selector('label', text: I18n.t('labels.category')) }

  # Tests that section titles are displayed
  it { is_expected.to have_content(I18n.t('titles.quiz_form')) }
  it { is_expected.to have_content(I18n.t('titles.questions_section')) }

  # Tests that the question form partial is rendered for each question
  it 'renders the question partial for each question' do
    expect(view).to render_template(partial: 'quizzes/_question_form')
  end

  # Tests that the add question button is present with correct styling and link
  it { is_expected.to have_selector('a#add_question_button.btn.btn-success.btn-sm') }
  it { is_expected.to have_link(I18n.t('buttons.add_question'), href: add_question_quizzes_path(question_index: indexes.question_index)) }

  # Tests that the submit button is present
  it { is_expected.to have_selector("input[type='submit']") }
end
