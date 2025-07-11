# frozen_string_literal: true

# Factory for creating QuestionResult instances with various configurations
# Creates question results with default values for testing evaluation results
#
# @example
#   create(:question_result) # Creates a correct answer result
#   create(:question_result, correct: false) # Creates an incorrect answer result
#
FactoryBot.define do
  factory :question_result do
    question_id { '1' }
    correct_answer_id { '1' }
    user_answer_id { '1' }
    correct { true }

    # Uses custom initialization to match the QuestionResult constructor signature
    initialize_with { new(question_id: question_id, correct_answer_id: correct_answer_id, user_answer_id: user_answer_id, correct: correct) }
  end
end
