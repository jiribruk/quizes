# frozen_string_literal: true

require 'rails_helper'

describe Quiz, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:questions).inverse_of(:quiz).dependent(:destroy) }
  end

  describe 'default_scope' do
    let!(:quiz_a) { create(:quiz, name: 'Alpha') }
    let!(:quiz_b) { create(:quiz, name: 'Beta') }
    let!(:quiz_c) { create(:quiz, name: 'Charlie') }

    subject(:quizzes) { Quiz.all.pluck(:name) }

    it { is_expected.to eq(%w[Alpha Beta Charlie]) }
  end
end
