# frozen_string_literal: true

require 'rails_helper'

# Model specs for Quiz covering validations, associations, and default scope
#
# @see Quiz
describe Quiz, type: :model do
  # Tests presence validation for quiz name
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  # Tests association with questions including inverse relationship and dependent destroy
  describe 'associations' do
    it { is_expected.to have_many(:questions).inverse_of(:quiz).dependent(:destroy) }
  end

  # Tests default scope that orders quizzes by name in ascending order
  describe 'default_scope' do
    let!(:quiz_a) { create(:quiz, name: 'Alpha') }
    let!(:quiz_b) { create(:quiz, name: 'Beta') }
    let!(:quiz_c) { create(:quiz, name: 'Charlie') }

    subject(:quizzes) { Quiz.all.pluck(:name) }

    it { is_expected.to eq(%w[Alpha Beta Charlie]) }
  end
end
