# frozen_string_literal: true

require 'rails_helper'

describe Question, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:answers).inverse_of(:question).dependent(:destroy) }
    it { is_expected.to belong_to(:quiz).inverse_of(:questions).optional(false) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }

    describe 'exactly_one_correct_answer validation' do
      subject(:question) { build(:question, answers: [answer_a, answer_b]) }
      before(:each) { question.valid? }

      context 'when no answer is correct' do
        let(:answer_a) { build(:answer, correct: false) }
        let(:answer_b) { build(:answer, correct: false) }

        it { is_expected.not_to be_valid }
        it { expect(question.errors[:base]).to include(I18n.t('validation_errors.exactly_one_correct_answer')) }
      end

      context 'when more than one answer is correct' do
        let(:answer_a) { build(:answer, correct: true) }
        let(:answer_b) { build(:answer, correct: true) }

        it { is_expected.not_to be_valid }
        it { expect(question.errors[:base]).to include(I18n.t('validation_errors.exactly_one_correct_answer')) }
      end

      context 'when exactly one answer is correct' do
        let(:answer_a) { build(:answer, correct: true) }
        let(:answer_b) { build(:answer, correct: false) }

        it { is_expected.to be_valid }
      end
    end
  end

  describe 'default_scope' do
    let!(:question_a) { create(:question, :with_answers, text: 'Alpha') }
    let!(:question_b) { create(:question, :with_answers, text: 'Beta') }
    let!(:question_c) { create(:question, :with_answers, text: 'Charlie') }

    subject(:questions) { Question.all.pluck(:text) }

    it { is_expected.to eq(%w[Alpha Beta Charlie]) }
  end
end
