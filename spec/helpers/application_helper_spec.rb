# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#title' do
    subject(:html_title) { title(text: 'Test') }
    it { is_expected.to have_selector('h1.mb-4', text: 'Test') }
  end
end
