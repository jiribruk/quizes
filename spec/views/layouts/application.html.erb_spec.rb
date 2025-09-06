# frozen_string_literal: true

require 'rails_helper'

# View specs for application layout
# Tests navbar functionality with authentication
#
# @see app/views/layouts/application.html.erb
describe 'layouts/application', type: :view do
  describe 'navbar' do
    context 'when user is not signed in' do
      before do
        allow(view).to receive(:user_signed_in?).and_return(false)
        allow(view).to receive(:current_user).and_return(nil)
      end

      it 'shows login and registration links' do
        render

        expect(rendered).to have_link(I18n.t('devise.shared.links.sign_in'), href: new_user_session_path)
        expect(rendered).to have_link(I18n.t('devise.shared.links.sign_up'), href: new_user_registration_path)
        expect(rendered).to have_link(I18n.t('buttons.home'), href: root_path)
      end
    end

    context 'when user is signed in' do
      let(:user) { create(:user, email: 'test@example.com') }

      before do
        allow(view).to receive(:user_signed_in?).and_return(true)
        allow(view).to receive(:current_user).and_return(user)
      end

      it 'shows user info and logout link' do
        render

        expect(rendered).to have_link(I18n.t('users.navbar.edit_profile'), href: edit_user_registration_path)
        expect(rendered).to have_link(I18n.t('devise.sessions.signed_out'), href: destroy_user_session_path)
        expect(rendered).to have_link(I18n.t('buttons.home'), href: root_path)
      end
    end
  end
end
