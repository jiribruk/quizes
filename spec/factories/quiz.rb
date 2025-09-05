# frozen_string_literal: true

# Factory for creating Quiz instances with various configurations
# Provides traits for creating quizzes with associated questions and answers
#
# @example
#   create(:quiz) # Creates a basic quiz
#   create(:quiz, :with_questions) # Creates a quiz with one question
#   create(:quiz, :with_questions_and_answers) # Creates a quiz with question and answers
#
FactoryBot.define do
  factory :quiz do
    sequence(:name) { |n| "Quiz name #{n}" }
    sequence(:category) { |n| "Category #{n}" }
    visibility { :public }

    # Trait for creating a quiz with one associated question
    trait :with_questions do
      questions { [build(:question)] }
    end

    # Trait for creating a quiz with one question and its associated answers
    trait :with_questions_and_answers do
      questions { [build(:question, :with_answers)] }
    end
  end
end
