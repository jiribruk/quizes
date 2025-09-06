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

    # Trait for creating a quiz with one associated question
    trait :with_questions do
      questions { [build(:question)] }
    end

    # Trait for creating a quiz with one question and its associated answers
    trait :with_questions_and_answers do
      questions { [build(:question, :with_answers)] }
    end

    # Trait for creating a quiz with 3 questions for feature tests (all in English)
    trait :with_three_questions do
      questions do
        [
          build(:question, text: 'What is 2+2?', answers: [
                  build(:answer, text: '3', correct: false),
                  build(:answer, text: '4', correct: true),
                  build(:answer, text: '5', correct: false)
                ]),
          build(:question, text: 'What is 3x3?', answers: [
                  build(:answer, text: '6', correct: false),
                  build(:answer, text: '9', correct: true),
                  build(:answer, text: '12', correct: false)
                ]),
          build(:question, text: 'What is 10-5?', answers: [
                  build(:answer, text: '3', correct: false),
                  build(:answer, text: '5', correct: true),
                  build(:answer, text: '7', correct: false)
                ])
        ]
      end
    end
  end
end
