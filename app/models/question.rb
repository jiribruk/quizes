# frozen_string_literal: true

# Question represents a question in a quiz.
class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy

  belongs_to :quiz, inverse_of: :questions, optional: false

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates_presence_of :text
  validate :exactly_one_correct_answer

  def correct_answer
    answers.where(correct: true).first
  end

  private

  def exactly_one_correct_answer
    return if answers.count(&:correct) == 1

    errors.add(:base, I18n.t('valiation_errors.exactly_one_correct_answer'))
  end
end
