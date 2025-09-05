# frozen_string_literal: true

require 'rails_helper'

# Model specs for User with Devise authentication
# Tests user creation, validation, and authentication methods
#
# @see User
describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is invalid without email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('je povinná položka')
    end

    it 'is invalid with duplicate email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('již databáze obsahuje')
    end

    it 'is invalid without password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('je povinná položka')
    end

    it 'is invalid with short password' do
      user = build(:user, password: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('je příliš krátký/á/é (min. 6 znaků)')
    end

    it 'is invalid with mismatched password confirmation' do
      user = build(:user, password: 'password123', password_confirmation: 'different123')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include('nebylo potvrzeno')
    end
  end

  describe 'authentication' do
    let(:user) { create(:user, password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.valid_password?('password123')).to be true
    end

    it 'does not authenticate with incorrect password' do
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end

  describe 'display_name' do
    let(:user) { create(:user, email: 'test@example.com') }

    it 'returns email as display name' do
      expect(user.display_name).to eq('test@example.com')
    end
  end

  describe 'Devise modules' do
    it 'includes database_authenticatable' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable' do
      expect(User.devise_modules).to include(:validatable)
    end
  end
end
