# frozen_string_literal: true

require 'rails_helper'

describe QuizResult do
  subject(:quiz_result) { described_class.new }

  describe '#initialize' do
    it { expect(quiz_result.score).to eq(0) }
    it { expect(quiz_result.question_results).to eq([]) }
  end

  describe '#add_question_result' do
    let(:question_result) { double('QuestionResult') }

    it 'adds a question result to the array' do
      expect { quiz_result.add_question_result(question_result) }
        .to change { quiz_result.question_results.size }.by(1)
      expect(quiz_result.question_results).to include(question_result)
    end
  end

  describe '#increase_score' do
    it { expect { quiz_result.increase_score }.to change { quiz_result.score }.by(1) }
  end
end
