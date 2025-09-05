# frozen_string_literal: true

require 'rails_helper'

# Model tests for QuizUserGroup functionality
# Tests the join table between quizzes and user groups
#
# @see QuizUserGroup
describe QuizUserGroup, type: :model do
  let(:quiz) { create(:quiz) }
  let(:user_group) { create(:user_group) }

  describe 'validations' do
    let(:quiz_user_group_no_quiz) { build(:quiz_user_group, quiz: nil, user_group: user_group) }
    let(:quiz_user_group_no_group) { build(:quiz_user_group, quiz: quiz, user_group: nil) }
    let(:valid_quiz_user_group) { build(:quiz_user_group, quiz: quiz, user_group: user_group) }

    it 'requires quiz' do
      expect(quiz_user_group_no_quiz).not_to be_valid
      expect(quiz_user_group_no_quiz.errors[:quiz]).to include('musí existovat')
    end

    it 'requires user_group' do
      expect(quiz_user_group_no_group).not_to be_valid
      expect(quiz_user_group_no_group.errors[:user_group]).to include('musí existovat')
    end

    it 'is valid with quiz and user_group' do
      expect(valid_quiz_user_group).to be_valid
    end
  end

  describe 'uniqueness' do
    it 'prevents duplicate quiz sharing' do
      create(:quiz_user_group, quiz: quiz, user_group: user_group)
      duplicate_sharing = build(:quiz_user_group, quiz: quiz, user_group: user_group)
      expect(duplicate_sharing).not_to be_valid
      expect(duplicate_sharing.errors[:quiz_id]).to include('is already shared with this group')
    end

    it 'allows same quiz shared with different groups' do
      other_group = create(:user_group)
      create(:quiz_user_group, quiz: quiz, user_group: user_group)
      other_sharing = build(:quiz_user_group, quiz: quiz, user_group: other_group)
      expect(other_sharing).to be_valid
    end

    it 'allows different quizzes shared with same group' do
      other_quiz = create(:quiz)
      create(:quiz_user_group, quiz: quiz, user_group: user_group)
      other_sharing = build(:quiz_user_group, quiz: other_quiz, user_group: user_group)
      expect(other_sharing).to be_valid
    end
  end

  describe 'associations' do
    let!(:quiz_user_group) { create(:quiz_user_group, quiz: quiz, user_group: user_group) }

    it 'belongs to quiz' do
      expect(quiz_user_group.quiz).to eq(quiz)
    end

    it 'belongs to user_group' do
      expect(quiz_user_group.user_group).to eq(user_group)
    end
  end
end
