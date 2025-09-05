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

        expect(rendered).to have_link('Přihlásit se', href: new_user_session_path)
        expect(rendered).to have_link('Zaregistrovat se', href: new_user_registration_path)
        expect(rendered).to have_link('Domů', href: root_path)
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

        expect(rendered).to have_link('Upravit profil', href: edit_user_registration_path)
        expect(rendered).to have_link('Odhlášen(a).', href: destroy_user_session_path)
        expect(rendered).to have_link('Domů', href: root_path)
      end
    end
  end
end
