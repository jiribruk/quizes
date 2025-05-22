# frozen_string_literal: true

FactoryBot.define do
  factory :quiz do
    sequence(:name) { |n| "Quiz name #{n}" }
  end
end
