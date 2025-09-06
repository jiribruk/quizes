# frozen_string_literal: true

require 'rails_helper'

# Request specs for UserGroupsController
# Tests CRUD operations and authorization for user groups
#
# @see UserGroupsController
RSpec.describe 'UserGroups', type: :request do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:user_group) { create(:user_group, owner: owner) }

  describe 'GET /user_groups' do
    context 'when user is not signed in' do
      it 'redirects to login' do
        get user_groups_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before { sign_in owner }

      it 'returns success' do
        get user_groups_path
        expect(response).to have_http_status(:success)
      end

      it 'shows only owned groups' do
        create(:user_group, owner: owner, name: 'My Group')
        create(:user_group, owner: other_user, name: 'Other Group')

        get user_groups_path
        expect(response.body).to include('My Group')
        expect(response.body).not_to include('Other Group')
      end
    end
  end

  describe 'GET /user_groups/:id' do
    context 'when user is not signed in' do
      it 'redirects to login' do
        get user_group_path(user_group)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before { sign_in owner }

      it 'returns success for owned group' do
        get user_group_path(user_group)
        expect(response).to have_http_status(:success)
      end

      it 'shows group details' do
        get user_group_path(user_group)
        expect(response.body).to include(user_group.name)
        expect(response.body).to include(user_group.description)
      end
    end

    context 'when accessing other user group' do
      before { sign_in other_user }

      it 'allows access to any group (for now)' do
        get user_group_path(user_group)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /user_groups/new' do
    context 'when user is not signed in' do
      it 'redirects to login' do
        get new_user_group_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before { sign_in owner }

      it 'returns success' do
        get new_user_group_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /user_groups' do
    let(:valid_params) { { user_group: { name: 'Test Group', description: 'Test Description' } } }

    context 'when user is not signed in' do
      it 'redirects to login' do
        post user_groups_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before { sign_in owner }

      context 'with valid parameters' do
        it 'creates a new user group' do
          expect do
            post user_groups_path, params: valid_params
          end.to change(UserGroup, :count).by(1)
        end

        it 'redirects to the created group' do
          post user_groups_path, params: valid_params
          expect(response).to redirect_to(user_group_path(UserGroup.last))
        end

        it 'sets the current user as owner' do
          post user_groups_path, params: valid_params
          expect(UserGroup.last.owner).to eq(owner)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) { { user_group: { name: '', description: 'Test' } } }

        it 'does not create a user group' do
          expect do
            post user_groups_path, params: invalid_params
          end.not_to change(UserGroup, :count)
        end

        it 'renders new template' do
          post user_groups_path, params: invalid_params
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET /user_groups/:id/edit' do
    context 'when user is not signed in' do
      it 'redirects to login' do
        get edit_user_group_path(user_group)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      context 'as owner' do
        before { sign_in owner }

        it 'returns success' do
          get edit_user_group_path(user_group)
          expect(response).to have_http_status(:success)
        end
      end

      context 'as non-owner' do
        before { sign_in other_user }

        it 'redirects to user groups index' do
          get edit_user_group_path(user_group)
          expect(response).to redirect_to(user_groups_path)
        end

        it 'shows ownership required message' do
          get edit_user_group_path(user_group)
          expect(flash[:alert]).to eq(I18n.t('user_groups.errors.ownership_required'))
        end
      end
    end
  end

  describe 'PATCH /user_groups/:id' do
    let(:update_params) { { user_group: { name: 'Updated Name', description: 'Updated Description' } } }

    context 'when user is not signed in' do
      it 'redirects to login' do
        patch user_group_path(user_group), params: update_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      context 'as owner' do
        before { sign_in owner }

        context 'with valid parameters' do
          it 'updates the user group' do
            patch user_group_path(user_group), params: update_params
            user_group.reload
            expect(user_group.name).to eq('Updated Name')
            expect(user_group.description).to eq('Updated Description')
          end

          it 'redirects to the group' do
            patch user_group_path(user_group), params: update_params
            expect(response).to redirect_to(user_group_path(user_group))
          end
        end

        context 'with invalid parameters' do
          let(:invalid_params) { { user_group: { name: '', description: 'Test' } } }

          it 'does not update the user group' do
            original_name = user_group.name
            patch user_group_path(user_group), params: invalid_params
            user_group.reload
            expect(user_group.name).to eq(original_name)
          end

          it 'renders edit template' do
            patch user_group_path(user_group), params: invalid_params
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'as non-owner' do
        before { sign_in other_user }

        it 'redirects to user groups index' do
          patch user_group_path(user_group), params: update_params
          expect(response).to redirect_to(user_groups_path)
        end

        it 'shows ownership required message' do
          patch user_group_path(user_group), params: update_params
          expect(flash[:alert]).to eq(I18n.t('user_groups.errors.ownership_required'))
        end

        it 'does not update the user group' do
          original_name = user_group.name
          patch user_group_path(user_group), params: update_params
          user_group.reload
          expect(user_group.name).to eq(original_name)
        end
      end
    end
  end

  describe 'DELETE /user_groups/:id' do
    context 'when user is not signed in' do
      it 'redirects to login' do
        delete user_group_path(user_group)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      context 'as owner' do
        before { sign_in owner }

        it 'deletes the user group' do
          expect do
            delete user_group_path(user_group)
          end.to change(UserGroup, :count).by(-1)
        end

        it 'redirects to user groups index' do
          delete user_group_path(user_group)
          expect(response).to redirect_to(user_groups_path)
        end
      end

      context 'as non-owner' do
        before { sign_in other_user }

        it 'redirects to user groups index' do
          delete user_group_path(user_group)
          expect(response).to redirect_to(user_groups_path)
        end

        it 'shows ownership required message' do
          delete user_group_path(user_group)
          expect(flash[:alert]).to eq(I18n.t('user_groups.errors.ownership_required'))
        end

        it 'does not delete the user group' do
          group = create(:user_group, owner: owner)
          expect do
            delete user_group_path(group)
          end.not_to change(UserGroup, :count)
        end
      end
    end
  end
end
