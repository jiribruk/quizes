# frozen_string_literal: true

require 'rails_helper'

# Model tests for Quiz visibility functionality
# Tests the visibility scopes, methods, and associations
#
# @see Quiz#visible_to_user
# @see Quiz#visible_to?
describe Quiz, type: :model do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:group_member) { create(:user) }
  let(:user_group) { create(:user_group, owner: owner) }

  describe 'visibility enum' do
    let(:private_quiz) { create(:quiz, visibility: :private, user: owner) }
    let(:public_quiz) { create(:quiz, visibility: :public, user: owner) }

    it 'has correct visibility values' do
      expect(Quiz.visibilities).to eq({ 'private' => 0, 'public' => 1 })
    end

    it 'defaults to public visibility' do
      quiz = build(:quiz, name: 'Test Quiz')
      expect(quiz.visibility).to eq('public')
    end

    it 'provides visibility_private? method' do
      expect(private_quiz.visibility_private?).to be true
      expect(private_quiz.visibility_public?).to be false
    end

    it 'provides visibility_public? method' do
      expect(public_quiz.visibility_public?).to be true
      expect(public_quiz.visibility_private?).to be false
    end
  end

  describe 'validations' do
    let(:private_quiz_no_user) { build(:quiz, visibility: :private, user: nil) }
    let(:public_quiz_no_user) { build(:quiz, visibility: :public, user: nil) }
    let(:public_quiz_with_user) { build(:quiz, visibility: :public, user: owner) }

    it 'requires user for private quizzes' do
      expect(private_quiz_no_user).not_to be_valid
      expect(private_quiz_no_user.errors[:user]).to include('je povinná položka')
    end

    it 'allows nil user for public quizzes' do
      expect(public_quiz_no_user).to be_valid
    end

    it 'allows user for public quizzes' do
      expect(public_quiz_with_user).to be_valid
    end
  end

  describe 'associations' do
    let!(:quiz) { create(:quiz, user: owner) }
    let!(:quiz_user_group) { create(:quiz_user_group, quiz: quiz, user_group: user_group) }

    it 'belongs to user' do
      expect(quiz.user).to eq(owner)
    end

    it 'has many quiz_user_groups' do
      expect(quiz.quiz_user_groups).to include(quiz_user_group)
    end

    it 'has many user_groups through quiz_user_groups' do
      expect(quiz.user_groups).to include(user_group)
    end
  end

  describe 'visible_to_user scope' do
    let!(:public_quiz) { create(:quiz, visibility: :public, user: owner) }
    let!(:private_quiz) { create(:quiz, visibility: :private, user: owner) }
    let!(:other_public_quiz) { create(:quiz, visibility: :public, user: other_user) }
    let!(:other_private_quiz) { create(:quiz, visibility: :private, user: other_user) }

    context 'when user is owner' do
      it 'returns all accessible quizzes' do
        visible_quizzes = Quiz.visible_to_user(owner)
        expect(visible_quizzes).to include(public_quiz)
        expect(visible_quizzes).to include(private_quiz)
        expect(visible_quizzes).to include(other_public_quiz)
        expect(visible_quizzes).not_to include(other_private_quiz)
      end
    end

    context 'when user is not owner' do
      it 'returns only public quizzes and own private quizzes' do
        visible_quizzes = Quiz.visible_to_user(other_user)
        expect(visible_quizzes).to include(public_quiz)
        expect(visible_quizzes).not_to include(private_quiz)
        expect(visible_quizzes).to include(other_public_quiz)
        expect(visible_quizzes).to include(other_private_quiz)
      end
    end

    context 'when user is member of group with private quiz' do
      let!(:private_quiz_with_group) { create(:quiz, visibility: :private, user: owner) }
      let!(:quiz_user_group) { create(:quiz_user_group, quiz: private_quiz_with_group, user_group: user_group) }

      before do
        create(:user_group_membership, user: group_member, user_group: user_group)
      end

      it 'returns private quiz for group member' do
        visible_quizzes = Quiz.visible_to_user(group_member)
        expect(visible_quizzes).to include(private_quiz_with_group)
      end
    end

    context 'when user is not member of group with private quiz' do
      let!(:private_quiz_with_group) { create(:quiz, visibility: :private, user: owner) }
      let!(:quiz_user_group) { create(:quiz_user_group, quiz: private_quiz_with_group, user_group: user_group) }

      it 'does not return private quiz for non-group member' do
        visible_quizzes = Quiz.visible_to_user(other_user)
        expect(visible_quizzes).not_to include(private_quiz_with_group)
      end
    end
  end

  describe 'visible_to? method' do
    let!(:public_quiz) { create(:quiz, visibility: :public, user: owner) }
    let!(:private_quiz) { create(:quiz, visibility: :private, user: owner) }

    context 'for public quiz' do
      it 'returns true for any user' do
        expect(public_quiz.visible_to?(owner)).to be true
        expect(public_quiz.visible_to?(other_user)).to be true
        expect(public_quiz.visible_to?(nil)).to be true
      end
    end

    context 'for private quiz' do
      it 'returns true for owner' do
        expect(private_quiz.visible_to?(owner)).to be true
      end

      it 'returns false for non-owner' do
        expect(private_quiz.visible_to?(other_user)).to be false
      end

      it 'returns false for nil user' do
        expect(private_quiz.visible_to?(nil)).to be false
      end
    end

    context 'for private quiz with user groups' do
      let!(:private_quiz_with_group) { create(:quiz, visibility: :private, user: owner) }
      let!(:quiz_user_group) { create(:quiz_user_group, quiz: private_quiz_with_group, user_group: user_group) }

      before do
        create(:user_group_membership, user: group_member, user_group: user_group)
      end

      it 'returns true for group member' do
        expect(private_quiz_with_group.visible_to?(group_member)).to be true
      end

      it 'returns false for non-group member' do
        expect(private_quiz_with_group.visible_to?(other_user)).to be false
      end

      it 'returns true for owner even if not in group' do
        expect(private_quiz_with_group.visible_to?(owner)).to be true
      end
    end
  end

  describe 'edge cases' do
    context 'when quiz has no user' do
      let!(:public_quiz_no_user) { create(:quiz, visibility: :public, user: nil) }

      it 'is visible to all users' do
        expect(public_quiz_no_user.visible_to?(owner)).to be true
        expect(public_quiz_no_user.visible_to?(other_user)).to be true
        expect(public_quiz_no_user.visible_to?(nil)).to be true
      end

      it 'appears in visible_to_user scope' do
        visible_quizzes = Quiz.visible_to_user(other_user)
        expect(visible_quizzes).to include(public_quiz_no_user)
      end
    end

    context 'when user is member of multiple groups' do
      let!(:group1) { create(:user_group, owner: owner) }
      let!(:group2) { create(:user_group, owner: owner) }
      let!(:private_quiz1) { create(:quiz, visibility: :private, user: owner) }
      let!(:private_quiz2) { create(:quiz, visibility: :private, user: owner) }
      let!(:quiz_group1) { create(:quiz_user_group, quiz: private_quiz1, user_group: group1) }
      let!(:quiz_group2) { create(:quiz_user_group, quiz: private_quiz2, user_group: group2) }

      before do
        create(:user_group_membership, user: group_member, user_group: group1)
        create(:user_group_membership, user: group_member, user_group: group2)
      end

      it 'can access quizzes from both groups' do
        expect(private_quiz1.visible_to?(group_member)).to be true
        expect(private_quiz2.visible_to?(group_member)).to be true
      end
    end

    context 'when quiz is shared with multiple groups' do
      let!(:group1) { create(:user_group, owner: owner) }
      let!(:group2) { create(:user_group, owner: owner) }
      let!(:private_quiz) { create(:quiz, visibility: :private, user: owner) }
      let!(:quiz_group1) { create(:quiz_user_group, quiz: private_quiz, user_group: group1) }
      let!(:quiz_group2) { create(:quiz_user_group, quiz: private_quiz, user_group: group2) }

      before do
        create(:user_group_membership, user: group_member, user_group: group1)
      end

      it 'can access quiz shared with multiple groups' do
        expect(private_quiz.visible_to?(group_member)).to be true
      end
    end
  end
end
