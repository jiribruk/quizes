FactoryBot.define do
  factory :question do
    quiz
    sequence(:text) { |n| "Question text #{n}" }
  end
end
