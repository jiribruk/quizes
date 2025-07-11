# frozen_string_literal: true

require 'rails_helper'

# Model specs for Answer covering validations, associations, and default scope
#
# @see Answer
describe Answer, type: :model do
  # Tests presence validation for answer text
  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
  end

  # Tests association with question including inverse relationship
  describe 'associations' do
    it { is_expected.to belong_to(:question).inverse_of(:answers).optional(false) }
  end

  # Tests default scope that orders answers by text in ascending order
  describe 'default_scope' do
    let!(:question) { create(:question, answers: [answer_a, answer_b, answer_c]) }
    let(:answer_a) { build(:answer, text: 'Alpha', correct: true) }
    let(:answer_b) { build(:answer, text: 'Beta', correct: false) }
    let(:answer_c) { build(:answer, text: 'Charlie', correct: false) }

    subject(:answers) { Answer.all.pluck(:text) }

    it { is_expected.to eq(%w[Alpha Beta Charlie]) }
  end
end
