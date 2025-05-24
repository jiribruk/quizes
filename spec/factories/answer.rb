# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:text) { |n| "Answer text #{n}" }
  end
end
