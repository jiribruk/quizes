# frozen_string_literal: true

# Question represents a question in a quiz with associated answers and optional image.
# Supports nested attributes for creating/updating answers and image attachments.
#
# @example
#   question = Question.new(text: "What is the capital of France?")
#   question.answers.build(text: "Paris", correct: true)
#   question.answers.build(text: "London", correct: false)
#   question.save
#
class Question < ApplicationRecord
  # Maximum size for question images in pixels
  IMAGE_SIZE = 250

  # @return [ActiveRecord::Associations::CollectionProxy] the answers associated with this question
  has_many :answers, inverse_of: :question, dependent: :destroy

  # @return [ActiveStorage::Attached::One] the image attached to this question
  has_one_attached :image, dependent: :destroy

  # @return [Quiz] the quiz this question belongs to
  belongs_to :quiz, inverse_of: :questions, optional: false

  # Allows nested attributes for answers, including destroy functionality
  accepts_nested_attributes_for :answers, allow_destroy: true
  # Allows nested attributes for image attachment, including destroy functionality
  accepts_nested_attributes_for :image_attachment, allow_destroy: true

  # @return [String] the text of the question
  validates_presence_of :text
  # Validates that exactly one answer is marked as correct
  validate :exactly_one_correct_answer

  # Orders questions by text in ascending order
  default_scope { order(text: :asc) }

  # Returns the correct answer for this question
  #
  # @return [Answer, nil] the correct answer or nil if not found
  def correct_answer
    answers.find_by(correct: true)
  end

  private

  # Validates that exactly one answer is marked as correct
  # Adds error to base if validation fails
  #
  # @return [void]
  def exactly_one_correct_answer
    return if answers.count(&:correct) == 1

    errors.add(:base, I18n.t('validation_errors.exactly_one_correct_answer'))
  end
end
