# frozen_string_literal: true

# Quiz represents a quiz entity with associated questions.
# Supports nested attributes for creating/updating questions and answers.
#
# @example
#   quiz = Quiz.new(name: "Math Quiz", category: "Mathematics")
#   quiz.questions.build(text: "What is 2+2?")
#   quiz.save
#
class Quiz < ApplicationRecord
  # @return [ActiveRecord::Associations::CollectionProxy] the questions associated with this quiz
  has_many :questions, inverse_of: :quiz, dependent: :destroy

  # @return [String] the name of the quiz
  validates_presence_of :name

  # Orders quizzes by name in ascending order
  default_scope { order(name: :asc) }

  # Allows nested attributes for questions, including destroy functionality
  accepts_nested_attributes_for :questions, allow_destroy: true
end
