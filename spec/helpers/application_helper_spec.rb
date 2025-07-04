# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#title' do
    subject(:html_title) { title(text: 'Test') }
    it { is_expected.to have_selector('h1.mb-4', text: 'Test') }
  end

  describe '#top_navbar' do
    subject(:navbar) { top_navbar }

    it { is_expected.to have_selector('nav.navbar.border-bottom') }
    it { is_expected.to have_link(t("buttons.home"), href: root_path) }
    it { is_expected.to have_selector('nav[style*="#FFA500"]') }
  end
end
