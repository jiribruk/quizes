# frozen_string_literal: true

# Answer represents an answer to a question in a quiz.
class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers, optional: false

  validates_presence_of :text

  default_scope { order(text: :asc) }
end
