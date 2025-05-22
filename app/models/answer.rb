# frozen_string_literal: true

# Answer represents an answer to a question in a quiz.
#
# @see https://guides.rubyonrails.org/active_record_basics.html
class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers, optional: false

  validates :text, presence: true
end
