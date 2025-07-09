# frozen_string_literal: true

# Answer represents an answer to a question in a quiz.
# Each answer can be marked as correct or incorrect.
#
# @example
#   answer = Answer.new(text: "Paris", correct: true)
#   answer.question = question
#   answer.save
#
class Answer < ApplicationRecord
  # @return [Question] the question this answer belongs to
  belongs_to :question, inverse_of: :answers, optional: false

  # @return [String] the text of the answer
  validates_presence_of :text

  # Orders answers by text in ascending order
  default_scope { order(text: :asc) }
end
