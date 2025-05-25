# frozen_string_literal: true

# Quiz represents a quiz entity.
class Quiz < ApplicationRecord
  has_many :questions, inverse_of: :quiz, dependent: :destroy

  validates_presence_of :name

  default_scope { order(name: :asc) }
end
