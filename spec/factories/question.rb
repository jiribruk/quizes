# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "Question text #{n}" }
    quiz
    trait :with_answers do
      answers { [build(:answer, correct: true), build(:answer, correct: false)] }
    end
  end
end
