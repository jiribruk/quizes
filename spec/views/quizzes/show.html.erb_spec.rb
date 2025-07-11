# frozen_string_literal: true

require 'rails_helper'

# View specs for quiz show page
# Tests the display of quiz details, questions, answers, and evaluation form
#
# @see QuizzesController#show
describe 'quizzes/show', type: :view do
  # Creates test quiz with questions and answers using build_stubbed for performance
  let!(:quiz) { build_stubbed(:quiz, questions: [question1, question2]) }
  let(:question1) { build_stubbed(:question, text: 'Question 1', answers: [answer1]) }
  let(:question2) { build_stubbed(:question, text: 'Question 2', answers: [answer2]) }
  let(:answer1) { build_stubbed(:answer, text: 'Answer 1') }
  let(:answer2) { build_stubbed(:answer, text: 'Answer 2') }

  # Assigns quiz to the view instance variable
  before { assign(:quiz, quiz) }

  # Subject for testing the rendered view
  subject(:rendered) { render }

  # Tests that the page displays the quiz name and edit link
  it { is_expected.to have_selector('h1', text: quiz.name) }
  it { is_expected.to have_link('✏', href: edit_quiz_path(quiz)) }
  it { is_expected.to have_selector("span[id='score_marker']") }

  # Tests that questions are displayed with their text
  it { is_expected.to have_selector('h4', text: question1.text) }
  it { is_expected.to have_selector('h4', text: question2.text) }

  # Tests that answers are displayed as labels
  it { is_expected.to have_selector('label', text: answer1.text) }
  it { is_expected.to have_selector('label', text: answer2.text) }

  # Tests that radio buttons are created for each question
  it { is_expected.to have_selector("input[type='radio'][name='answers[#{question1.id}]']") }
  it { is_expected.to have_selector("input[type='radio'][name='answers[#{question2.id}]']") }

  # Tests that answer markers are present for evaluation results
  it { is_expected.to have_selector("span[id='answer_#{answer1.id}_marker']") }
  it { is_expected.to have_selector("span[id='answer_#{answer2.id}_marker']") }

  # Tests that the evaluation form is present with correct action and method
  it { is_expected.to have_selector("form[action='#{evaluation_quiz_path(quiz)}'][method='post']") }

  # Tests that the submit button is present with correct attributes
  it { is_expected.to have_button(I18n.t('buttons.submit')) }
  it { is_expected.to have_selector("input[type='submit'][data-controller='quizzes'][data-quizzes-target='submit']") }

  # Tests display of questions with attached images
  context 'when a question has an attached image' do
    let(:question_with_image) { build_stubbed(:question, text: 'Question with image', answers: [answer1]) }

    before do
      allow(question_with_image).to receive_message_chain(:image, :attached?).and_return(true)
      allow(view).to receive(:url_for).and_return('/image.png')
      assign(:quiz, build_stubbed(:quiz, questions: [question_with_image]))
    end

    subject(:rendered) { render }

    # Tests that the image is displayed with the correct CSS class
    it { is_expected.to have_selector('img.img-thumbnail') }
  end
end
