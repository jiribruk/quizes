# frozen_string_literal: true

require 'rails_helper'

# Model tests for UserGroup functionality
# Tests the associations, validations, and basic functionality
#
# @see UserGroup
describe UserGroup, type: :model do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'validations' do
    let(:user_group_no_name) { build(:user_group, name: nil, description: 'Test description', owner: owner) }
    let(:user_group_no_owner) { build(:user_group, name: 'Test Group', description: 'Test description', owner: nil) }
    let(:valid_user_group) { build(:user_group, name: 'Test Group', description: 'Test description', owner: owner) }

    it 'requires name' do
      expect(user_group_no_name).not_to be_valid
      expect(user_group_no_name.errors[:name]).to include('je povinná položka')
    end

    it 'requires owner' do
      expect(user_group_no_owner).not_to be_valid
      expect(user_group_no_owner.errors[:owner]).to include('musí existovat')
    end

    it 'is valid with name and owner' do
      expect(valid_user_group).to be_valid
    end
  end

  describe 'associations' do
    let!(:user_group) { create(:user_group, owner: owner) }
    let!(:membership) { create(:user_group_membership, user: member, user_group: user_group) }
    let!(:quiz) { create(:quiz, user: owner) }
    let!(:quiz_user_group) { create(:quiz_user_group, quiz: quiz, user_group: user_group) }

    it 'belongs to owner' do
      expect(user_group.owner).to eq(owner)
    end

    it 'has many user_group_memberships' do
      expect(user_group.user_group_memberships).to include(membership)
    end

    it 'has many members through user_group_memberships' do
      expect(user_group.users).to include(member)
    end

    it 'has many quiz_user_groups' do
      expect(user_group.quiz_user_groups).to include(quiz_user_group)
    end

    it 'has many quizzes through quiz_user_groups' do
      expect(user_group.quizzes).to include(quiz)
    end
  end

  describe 'membership management' do
    let!(:user_group) { create(:user_group, owner: owner) }

    it 'can add members' do
      expect do
        create(:user_group_membership, user: member, user_group: user_group)
      end.to change(user_group.users, :count).by(1)
    end

    it 'can remove members' do
      membership = create(:user_group_membership, user: member, user_group: user_group)
      expect do
        membership.destroy
      end.to change(user_group.users, :count).by(-1)
    end

    it 'prevents duplicate memberships' do
      create(:user_group_membership, user: member, user_group: user_group)
      duplicate_membership = build(:user_group_membership, user: member, user_group: user_group)
      expect(duplicate_membership).not_to be_valid
      expect(duplicate_membership.errors[:user_id]).to include('is already a member of this group')
    end
  end

  describe 'quiz sharing' do
    let!(:user_group) { create(:user_group, owner: owner) }
    let!(:quiz) { create(:quiz, user: owner) }

    it 'can share quiz with group' do
      expect do
        create(:quiz_user_group, quiz: quiz, user_group: user_group)
      end.to change(user_group.quizzes, :count).by(1)
    end

    it 'prevents duplicate quiz sharing' do
      create(:quiz_user_group, quiz: quiz, user_group: user_group)
      duplicate_sharing = build(:quiz_user_group, quiz: quiz, user_group: user_group)
      expect(duplicate_sharing).not_to be_valid
      expect(duplicate_sharing.errors[:quiz_id]).to include('is already shared with this group')
    end
  end
end
