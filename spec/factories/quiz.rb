FactoryBot.define do
  factory :quiz do
    sequence(:name) { |n| "Quiz name #{n}" }
  end
end
