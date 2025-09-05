# frozen_string_literal: true

require 'rails_helper'

# Request specs for Devise authentication
# Tests user registration, login, logout, and password reset functionality
#
# @see Devise::SessionsController, Devise::RegistrationsController
describe 'Devise Authentication', type: :request do
  describe 'User Registration' do
    context 'with valid attributes' do
      let(:user_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates new user and redirects' do
        expect do
          post user_registration_path, params: user_params
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid attributes' do
      let(:user_params) do
        {
          user: {
            email: 'invalid-email',
            password: '123',
            password_confirmation: 'different'
          }
        }
      end

      it 'does not create user and renders registration form' do
        expect do
          post user_registration_path, params: user_params
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('devise/registrations/new')
      end
    end
  end

  describe 'User Login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'logs in user and redirects' do
        post user_session_path, params: {
          user: {
            email: 'test@example.com',
            password: 'password123'
          }
        }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'does not log in user and renders login form' do
        post user_session_path, params: {
          user: {
            email: 'test@example.com',
            password: 'wrongpassword'
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('devise/sessions/new')
      end
    end
  end

  describe 'User Logout' do
    let(:user) { create(:user) }

    it 'logs out user and redirects' do
      sign_in user
      delete destroy_user_session_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'Password Reset' do
    let!(:user) { create(:user, email: 'test@example.com') }

    it 'sends password reset email' do
      expect do
        post user_password_path, params: { user: { email: 'test@example.com' } }
      end.to change { ActionMailer::Base.deliveries.count }.by(1)

      expect(response).to have_http_status(:redirect)
    end

    it 'does not send email for non-existent user' do
      expect do
        post user_password_path, params: { user: { email: 'nonexistent@example.com' } }
      end.not_to(change { ActionMailer::Base.deliveries.count })

      # Devise returns 422 for invalid email in paranoid mode
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'Access Control' do
    context 'when user is not authenticated' do
      it 'redirects to login for protected pages' do
        get quizzes_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'allows access to protected pages' do
        get quizzes_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
