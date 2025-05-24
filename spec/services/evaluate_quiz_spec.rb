# frozen_string_literal: true

require 'rails_helper'

describe EvaluateQuiz, type: :service do
  let(:quiz) { create(:quiz) }
  let!(:question1) { create(:question, quiz: quiz, answers: [answer1_q1, answer2_q1]) }
  let!(:question2) { create(:question, quiz: quiz, answers: [answer1_q2, answer2_q2]) }
  let(:answer1_q1) { build(:answer, correct: true) }
  let(:answer2_q1) { build(:answer, correct: false) }
  let(:answer1_q2) { build(:answer, correct: true) }
  let(:answer2_q2) { build(:answer, correct: false) }

  let(:user_answers) do
    {
      question1.id.to_s => answer1_q1.id,
      question2.id.to_s => answer1_q2.id
    }
  end

  subject(:results) { described_class.call(quiz:, user_answers:) }

  def expect_result(index:, question:, answer:)
    expect(results[index]).to be_a(QuestionResult)
    expect(results[index].question_id).to eq(question.id)
    expect(results[index].correct_answer_id).to eq(answer.id)
    expect(results[index].user_answer_id).to eq(answer.id)
  end

  it 'returns correct evaluation results for each question' do
    expect(results.size).to eq(2)
    expect_result(index: 0, question: question1, answer: answer1_q1)
    expect_result(index: 1, question: question2, answer: answer1_q2)
  end
end
