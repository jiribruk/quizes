# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#heading' do
    it 'renders an h1 tag with the given text and class' do
      expect(heading(text: 'Test')).to eq('<h1 class="mb-4">Test</h1>')
    end
  end

  describe '#top_navbar' do
    subject(:navbar) { top_navbar }

    it 'renders a nav element with the correct classes' do
      expect(navbar).to have_selector('nav.navbar.border-bottom')
    end

    it 'contains a link to the home page' do
      expect(navbar).to have_link('Home', href: root_path)
    end

    it 'applies the correct background style' do
      expect(navbar).to have_selector('nav[style*="#FFA500"]')
    end
  end
end
