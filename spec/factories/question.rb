# frozen_string_literal: true

# Factory for creating Question instances with various configurations
# Provides traits for creating questions with associated answers
#
# @example
#   create(:question) # Creates a basic question
#   create(:question, :with_answers) # Creates a question with two answers (one correct)
#
FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "Question text #{n}" }
    quiz

    # Trait for creating a question with two answers (one correct, one incorrect)
    trait :with_answers do
      answers { [build(:answer, correct: true), build(:answer, correct: false)] }
    end
  end
end
