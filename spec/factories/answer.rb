# frozen_string_literal: true

# Factory for creating Answer instances with various configurations
# Creates answers with sequential text and default correct status
#
# @example
#   create(:answer) # Creates a correct answer
#   create(:answer, correct: false) # Creates an incorrect answer
#
FactoryBot.define do
  factory :answer do
    sequence(:text) { |n| "Answer text #{n}" }
    correct { true }
  end
end
