# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'quizzes/show', type: :view do
  let!(:quiz) { build_stubbed(:quiz, questions: [question1, question2]) }
  let(:question1) { build_stubbed(:question, text: 'Question 1', answers: [answer1]) }
  let(:question2) { build_stubbed(:question, text: 'Question 2', answers: [answer2]) }
  let(:answer1) { build_stubbed(:answer, text: 'Answer 1') }
  let(:answer2) { build_stubbed(:answer, text: 'Answer 2') }

  subject(:rendered) { render }

  before { assign(:quiz, quiz) }

  it { is_expected.to have_selector('h1', text: quiz.name) }
  it { is_expected.to have_selector('h4', text: question1.text) }
  it { is_expected.to have_selector('h4', text: question2.text) }
  it { is_expected.to have_selector('label', text: answer1.text) }
  it { is_expected.to have_selector('label', text: answer2.text) }
  it { is_expected.to have_selector("input[type='radio'][name='answers[#{question1.id}]']") }
  it { is_expected.to have_selector("input[type='radio'][name='answers[#{question2.id}]']") }
end
