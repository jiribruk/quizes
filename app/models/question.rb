# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, inverse_of: :question

  belongs_to :quiz, inverse_of: :questions, optional: false

  validates_presence_of :text
end
