# frozen_string_literal: true

FactoryBot.define do
  factory :quiz do
    sequence(:name) { |n| "Quiz name #{n}" }
    sequence(:category) { |n| "Category #{n}" }

    trait :with_questions do
      questions { [build(:question)] }
    end

    trait :with_questions_and_answers do
      questions { [build(:question, :with_answers)] }
    end
  end
end
