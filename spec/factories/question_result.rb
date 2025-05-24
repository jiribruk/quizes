# frozen_string_literal: true

FactoryBot.define do
  factory :question_result do
    question_id { '1' }
    correct_answer_id { '1' }
    user_answer_id { '1' }
    correct { true }

    initialize_with { new(question_id: question_id, correct_answer_id: correct_answer_id, user_answer_id: user_answer_id, correct: correct) }
  end
end
