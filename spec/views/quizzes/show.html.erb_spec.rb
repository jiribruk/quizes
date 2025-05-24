# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'quizzes/show', type: :view do
  let!(:quiz) { build_stubbed(:quiz, questions: [question1, question2]) }
  let(:question1) { build_stubbed(:question, text: 'Question 1', answers: [answer1]) }
  let(:question2) { build_stubbed(:question, text: 'Question 2', answers: [answer2]) }
  let(:answer1) { build_stubbed(:answer, text: 'Answer 1') }
  let(:answer2) { build_stubbed(:answer, text: 'Answer 2') }

  before do
    assign(:quiz, quiz)
    render
  end

  it 'displays the quiz name' do
    expect(rendered).to include(quiz.name)
  end

  it 'displays the text of all questions' do
    expect(rendered).to include(question1.text)
    expect(rendered).to include(question2.text)
  end

  it 'displays the text of all answers' do
    expect(rendered).to include(answer1.text)
    expect(rendered).to include(answer2.text)
  end
end
