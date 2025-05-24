# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#heading' do
    it 'renders an h1 tag with the given text and class' do
      expect(helper.heading(text: 'Test')).to eq('<h1 class="mb-4">Test</h1>')
    end
  end
end
