# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question
    sequence(:text) { |n| "Answer text #{n}" }
  end
end
