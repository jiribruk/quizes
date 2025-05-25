# frozen_string_literal: true

require 'rails_helper'

describe EvaluateQuiz, type: :service do
  let(:quiz) { create(:quiz) }
  let!(:question1) do
    create(:question, text: 'Question 1', quiz: quiz, answers: [answer1_q1, answer2_q1])
  end
  let(:answer1_q1) { build(:answer, correct: true) }
  let(:answer2_q1) { build(:answer, correct: false) }

  let!(:question2) do
    create(:question, text: 'Question 2', quiz: quiz, answers: [answer1_q2, answer2_q2])
  end
  let(:answer1_q2) { build(:answer, correct: true) }
  let(:answer2_q2) { build(:answer, correct: false) }

  let(:user_answers) do
    {
      question1.id.to_s => answer1_q1.id.to_s,
      question2.id.to_s => answer2_q2.id.to_s
    }
  end

  subject(:result) { described_class.call(quiz:, user_answers:) }

  def expect_result(index:, question:, answer:, correct_answer:)
    question_result = result.question_results[index]
    expect(question_result).to be_a(QuestionResult)
    expect(question_result.question_id).to eq(question.id.to_s)
    expect(question_result.correct_answer_id).to eq(correct_answer.id.to_s)
    expect(question_result.user_answer_id).to eq(answer.id.to_s)
    expect(question_result.correct).to eq(answer.correct)
  end

  it 'returns correct evaluation results for each question' do
    expect(result.question_results.size).to eq(2)
    expect_result(index: 0, question: question1, answer: answer1_q1, correct_answer: answer1_q1)
    expect_result(index: 1, question: question2, answer: answer2_q2, correct_answer: answer1_q2)
    expect(result.score).to eq(1)
    expect(result.questions_count).to eq(2)
  end
end
