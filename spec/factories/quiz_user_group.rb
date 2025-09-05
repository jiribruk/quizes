# frozen_string_literal: true

# Factory for creating QuizUserGroup instances
# Represents the join table between quizzes and user groups
#
# @example
#   create(:quiz_user_group) # Creates a basic quiz-user group association
#
FactoryBot.define do
  factory :quiz_user_group do
    association :quiz, factory: :quiz
    association :user_group, factory: :user_group
  end
end
