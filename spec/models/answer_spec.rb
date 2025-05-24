# frozen_string_literal: true

require 'rails_helper'

describe Answer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:question).inverse_of(:answers).optional(false) }
  end
end
