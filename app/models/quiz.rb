# frozen_string_literal: true

class Quiz < ApplicationRecord
  has_many :questions, inverse_of: :quiz

  validates_presence_of :name
end
