# frozen_string_literal: true

require 'rails_helper'

# Comprehensive security tests for quiz visibility system
# Tests that private quizzes are only visible to authorized users
# and that public quizzes are visible to all authenticated users
#
# @see Quiz#visible_to_user
# @see Quiz#visible_to?
describe 'Quiz Visibility Security', type: :request do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:group_member) { create(:user) }
  let(:non_member) { create(:user) }

  # Test public quiz visibility
  describe 'Public Quiz Visibility' do
    let!(:public_quiz) { create(:quiz, visibility: :public, user: owner) }

    context 'when user is authenticated' do
      before { sign_in other_user }

      it 'allows access to public quiz via index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(public_quiz.name)
      end

      it 'allows direct access to public quiz' do
        get quiz_path(public_quiz)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end

      it 'allows evaluation of public quiz' do
        post evaluation_quiz_path(public_quiz), params: { answers: {} }, as: :turbo_stream
        expect(response).to have_http_status(:success)
      end

      it 'denies edit access to non-owner' do
        get edit_quiz_path(public_quiz)
        expect(response).to redirect_to(quiz_path(public_quiz))
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.ownership_required'))
      end

      it 'denies update access to non-owner' do
        patch quiz_path(public_quiz), params: { quiz: { name: 'Hacked' } }
        expect(response).to redirect_to(quiz_path(public_quiz))
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.ownership_required'))
      end

      it 'denies delete access to non-owner' do
        delete quiz_path(public_quiz)
        expect(response).to redirect_to(quiz_path(public_quiz))
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.ownership_required'))
      end
    end

    context 'when user is not authenticated' do
      it 'denies access to public quiz' do
        get quiz_path(public_quiz)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # Test private quiz visibility
  describe 'Private Quiz Visibility' do
    let!(:private_quiz) { create(:quiz, visibility: :private, user: owner) }

    context 'when accessed by owner' do
      before { sign_in owner }

      it 'allows access to private quiz via index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(private_quiz.name)
      end

      it 'allows direct access to private quiz' do
        get quiz_path(private_quiz)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end

      it 'allows edit access to private quiz' do
        get edit_quiz_path(private_quiz)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end

      it 'allows update access to private quiz' do
        patch quiz_path(private_quiz), params: { quiz: { name: 'Updated' } }
        expect(response).to redirect_to(quiz_path(private_quiz))
        expect(private_quiz.reload.name).to eq('Updated')
      end

      it 'allows delete access to private quiz' do
        expect do
          delete quiz_path(private_quiz)
        end.to change(Quiz, :count).by(-1)
        expect(response).to redirect_to(root_path)
      end

      it 'allows evaluation of private quiz' do
        post evaluation_quiz_path(private_quiz), params: { answers: {} }, as: :turbo_stream
        expect(response).to have_http_status(:success)
      end
    end

    context 'when accessed by non-owner' do
      before { sign_in other_user }

      it 'denies access to private quiz via index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include(private_quiz.name)
      end

      it 'denies direct access to private quiz' do
        get quiz_path(private_quiz)
        expect(response).to redirect_to(quizzes_path)
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.access_denied'))
      end

      it 'denies edit access to private quiz' do
        get edit_quiz_path(private_quiz)
        expect(response).to redirect_to(quizzes_path)
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.access_denied'))
      end

      it 'denies update access to private quiz' do
        patch quiz_path(private_quiz), params: { quiz: { name: 'Hacked' } }
        expect(response).to redirect_to(quizzes_path)
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.access_denied'))
      end

      it 'denies delete access to private quiz' do
        expect do
          delete quiz_path(private_quiz)
        end.not_to change(Quiz, :count)
        expect(response).to redirect_to(quizzes_path)
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.access_denied'))
      end

      it 'denies evaluation of private quiz' do
        post evaluation_quiz_path(private_quiz), params: { answers: {} }, as: :turbo_stream
        expect(response).to redirect_to(quizzes_path)
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.access_denied'))
      end
    end

    context 'when accessed by unauthenticated user' do
      it 'denies access to private quiz' do
        get quiz_path(private_quiz)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # Test private quiz with user groups
  describe 'Private Quiz with User Groups' do
    let!(:user_group) { create(:user_group, owner: owner) }
    let!(:private_quiz) { create(:quiz, visibility: :private, user: owner) }
    let!(:quiz_user_group) { create(:quiz_user_group, quiz: private_quiz, user_group: user_group) }

    before do
      # Add group_member to the user group
      create(:user_group_membership, user: group_member, user_group: user_group)
    end

    context 'when accessed by group member' do
      before { sign_in group_member }

      it 'allows access to private quiz via index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(private_quiz.name)
      end

      it 'allows direct access to private quiz' do
        get quiz_path(private_quiz)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end

      it 'allows evaluation of private quiz' do
        post evaluation_quiz_path(private_quiz), params: { answers: {} }, as: :turbo_stream
        expect(response).to have_http_status(:success)
      end

      it 'denies edit access to group member' do
        get edit_quiz_path(private_quiz)
        expect(response).to redirect_to(quiz_path(private_quiz))
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.ownership_required'))
      end

      it 'denies update access to group member' do
        patch quiz_path(private_quiz), params: { quiz: { name: 'Hacked' } }
        expect(response).to redirect_to(quiz_path(private_quiz))
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.ownership_required'))
      end

      it 'denies delete access to group member' do
        expect do
          delete quiz_path(private_quiz)
        end.not_to change(Quiz, :count)
        expect(response).to redirect_to(quiz_path(private_quiz))
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.ownership_required'))
      end
    end

    context 'when accessed by non-group member' do
      before { sign_in non_member }

      it 'denies access to private quiz via index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include(private_quiz.name)
      end

      it 'denies direct access to private quiz' do
        get quiz_path(private_quiz)
        expect(response).to redirect_to(quizzes_path)
        expect(flash[:alert]).to eq(I18n.t('quiz.errors.access_denied'))
      end
    end
  end

  # Test mixed visibility scenarios
  describe 'Mixed Visibility Scenarios' do
    let!(:public_quiz) { create(:quiz, visibility: :public, user: owner) }
    let!(:private_quiz) { create(:quiz, visibility: :private, user: owner) }
    let!(:other_public_quiz) { create(:quiz, visibility: :public, user: other_user) }
    let!(:other_private_quiz) { create(:quiz, visibility: :private, user: other_user) }

    context 'when accessed by owner' do
      before { sign_in owner }

      it 'shows all quizzes in index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(public_quiz.name)
        expect(response.body).to include(private_quiz.name)
        expect(response.body).to include(other_public_quiz.name)
        expect(response.body).not_to include(other_private_quiz.name)
      end
    end

    context 'when accessed by other user' do
      before { sign_in other_user }

      it 'shows only public quizzes in index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(public_quiz.name)
        expect(response.body).not_to include(private_quiz.name)
        expect(response.body).to include(other_public_quiz.name)
        expect(response.body).to include(other_private_quiz.name)
      end
    end
  end

  # Test edge cases
  describe 'Edge Cases' do
    context 'when quiz has no user (public quiz)' do
      let!(:public_quiz_no_user) { create(:quiz, visibility: :public, user: nil) }

      before { sign_in other_user }

      it 'allows access to public quiz without user' do
        get quiz_path(public_quiz_no_user)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end

      it 'shows public quiz without user in index' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(public_quiz_no_user.name)
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
        sign_in group_member
      end

      it 'allows access to quizzes from both groups' do
        get quizzes_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(private_quiz1.name)
        expect(response.body).to include(private_quiz2.name)
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
        sign_in group_member
      end

      it 'allows access to quiz shared with multiple groups' do
        get quiz_path(private_quiz)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
    end
  end

  # Test model-level security
  describe 'Model-level Security' do
    let!(:public_quiz) { create(:quiz, visibility: :public, user: owner) }
    let!(:private_quiz) { create(:quiz, visibility: :private, user: owner) }

    context 'when using visible_to_user scope' do
      it 'returns only public quizzes for non-owner' do
        visible_quizzes = Quiz.visible_to_user(other_user)
        expect(visible_quizzes).to include(public_quiz)
        expect(visible_quizzes).not_to include(private_quiz)
      end

      it 'returns all accessible quizzes for owner' do
        visible_quizzes = Quiz.visible_to_user(owner)
        expect(visible_quizzes).to include(public_quiz)
        expect(visible_quizzes).to include(private_quiz)
      end
    end

    context 'when using visible_to? method' do
      it 'returns true for public quiz and any user' do
        expect(public_quiz.visible_to?(other_user)).to be true
      end

      it 'returns true for private quiz and owner' do
        expect(private_quiz.visible_to?(owner)).to be true
      end

      it 'returns false for private quiz and non-owner' do
        expect(private_quiz.visible_to?(other_user)).to be false
      end
    end
  end
end
