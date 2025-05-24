# frozen_string_literal: true

require 'rails_helper'

describe Quiz, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:questions).inverse_of(:quiz).dependent(:destroy) }
  end
end
