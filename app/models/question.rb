# frozen_string_literal: true

# Question represents a question in a quiz.
#
# @see https://guides.rubyonrails.org/active_record_basics.html
class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy

  belongs_to :quiz, inverse_of: :questions, optional: false

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :text, presence: true
  validate :one_answer_is_correct
  validate :only_one_correct_answer

  def correct_answer
    answers.where(correct: true).first
  end

  private

  def one_answer_is_correct
    return if answers.any?(&:correct?)

    errors.add(:base, "One answer must be correct.")
  end

  def only_one_correct_answer
    return if answers.where(correct: true).count <= 1

    errors.add(:base, "Only one answer can be correct.")
  end
end
