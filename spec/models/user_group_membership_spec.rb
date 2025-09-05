# frozen_string_literal: true

require 'rails_helper'

# Model tests for UserGroupMembership functionality
# Tests the join table between users and user groups
#
# @see UserGroupMembership
describe UserGroupMembership, type: :model do
  let(:user) { create(:user) }
  let(:user_group) { create(:user_group) }

  describe 'validations' do
    let(:membership_no_user) { build(:user_group_membership, user: nil, user_group: user_group) }
    let(:membership_no_group) { build(:user_group_membership, user: user, user_group: nil) }
    let(:valid_membership) { build(:user_group_membership, user: user, user_group: user_group) }

    it 'requires user' do
      expect(membership_no_user).not_to be_valid
      expect(membership_no_user.errors[:user]).to include('musí existovat')
    end

    it 'requires user_group' do
      expect(membership_no_group).not_to be_valid
      expect(membership_no_group.errors[:user_group]).to include('musí existovat')
    end

    it 'is valid with user and user_group' do
      expect(valid_membership).to be_valid
    end
  end

  describe 'uniqueness' do
    it 'prevents duplicate memberships' do
      create(:user_group_membership, user: user, user_group: user_group)
      duplicate_membership = build(:user_group_membership, user: user, user_group: user_group)
      expect(duplicate_membership).not_to be_valid
      expect(duplicate_membership.errors[:user_id]).to include('is already a member of this group')
    end

    it 'allows same user in different groups' do
      other_group = create(:user_group)
      create(:user_group_membership, user: user, user_group: user_group)
      other_membership = build(:user_group_membership, user: user, user_group: other_group)
      expect(other_membership).to be_valid
    end

    it 'allows different users in same group' do
      other_user = create(:user)
      create(:user_group_membership, user: user, user_group: user_group)
      other_membership = build(:user_group_membership, user: other_user, user_group: user_group)
      expect(other_membership).to be_valid
    end
  end

  describe 'associations' do
    let!(:membership) { create(:user_group_membership, user: user, user_group: user_group) }

    it 'belongs to user' do
      expect(membership.user).to eq(user)
    end

    it 'belongs to user_group' do
      expect(membership.user_group).to eq(user_group)
    end
  end
end
