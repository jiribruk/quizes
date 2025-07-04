# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/show', type: :view do
  let!(:quiz) { build_stubbed(:quiz, questions: [question1, question2]) }
  let(:question1) { build_stubbed(:question, text: 'Question 1', answers: [answer1]) }
  let(:question2) { build_stubbed(:question, text: 'Question 2', answers: [answer2]) }
  let(:answer1) { build_stubbed(:answer, text: 'Answer 1') }
  let(:answer2) { build_stubbed(:answer, text: 'Answer 2') }

  before { assign(:quiz, quiz) }

  subject(:rendered) { render }

  it { is_expected.to have_selector('h1', text: quiz.name) }
  it { is_expected.to have_link('✏', href: edit_quiz_path(quiz)) }
  it { is_expected.to have_selector("span[id='score_marker']") }

  it { is_expected.to have_selector('h4', text: question1.text) }
  it { is_expected.to have_selector('h4', text: question2.text) }

  it { is_expected.to have_selector('label', text: answer1.text) }
  it { is_expected.to have_selector('label', text: answer2.text) }

  it { is_expected.to have_selector("input[type='radio'][name='answers[#{question1.id}]']") }
  it { is_expected.to have_selector("input[type='radio'][name='answers[#{question2.id}]']") }

  it { is_expected.to have_selector("span[id='answer_#{answer1.id}_marker']") }
  it { is_expected.to have_selector("span[id='answer_#{answer2.id}_marker']") }

  it { is_expected.to have_selector("form[action='#{evaluation_quiz_path(quiz)}'][method='post']") }

  it { is_expected.to have_button(I18n.t('buttons.submit')) }
  it { is_expected.to have_selector("input[type='submit'][data-controller='quizzes'][data-quizzes-target='submit']") }

  context 'when a question has an attached image' do
    let(:question_with_image) { build_stubbed(:question, text: 'Question with image', answers: [answer1]) }

    before do
      allow(question_with_image).to receive_message_chain(:image, :attached?).and_return(true)
      allow(view).to receive(:url_for).and_return('/image.png')
      assign(:quiz, build_stubbed(:quiz, questions: [question_with_image]))
    end

    subject(:rendered) { render }

    it { is_expected.to have_selector('img.img-thumbnail') }
  end
end
