# frozen_string_literal: true

class Answer
  belongs_to :question, inverse_of: :answers

  validates_presence_of :text
end
