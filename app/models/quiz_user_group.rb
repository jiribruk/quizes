# frozen_string_literal: true

# QuizUserGroup represents the relationship between quizzes and user groups.
# This allows quizzes to be shared with specific groups of users.
#
# @example
#   quiz_user_group = QuizUserGroup.create(quiz: quiz, user_group: group)
#
class QuizUserGroup < ApplicationRecord
  # Associations
  belongs_to :quiz
  belongs_to :user_group

  # Validations
  validates :quiz, presence: true
  validates :user_group, presence: true
  validates :quiz_id, uniqueness: { scope: :user_group_id, message: 'is already shared with this group' }

  # Scopes
  scope :for_quiz, ->(quiz) { where(quiz: quiz) }
  scope :for_group, ->(group) { where(user_group: group) }
end
