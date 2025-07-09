# frozen_string_literal: true

# Indexes manages question and answer indexes for dynamic form generation.
# Used to track unique identifiers for nested form fields in quiz creation/editing.
#
# @example
#   indexes = Indexes.new(question_index: 0, answer_index: 0)
#   indexes.question_index_up # => 1
#   indexes.answer_index_up   # => 1
#
class Indexes
  # @return [Integer] the current question index
  attr_reader :question_index
  # @return [Integer] the current answer index
  attr_reader :answer_index

  # Initializes a new Indexes instance with optional starting indexes
  #
  # @param question_index [Integer] the starting question index (default: 0)
  # @param answer_index [Integer] the starting answer index (default: 0)
  def initialize(question_index: 0, answer_index: 0)
    @question_index = question_index
    @answer_index = answer_index
  end

  # Increments the question index by 1
  #
  # @return [Integer] the new question index
  def question_index_up
    @question_index += 1
  end

  # Increments the answer index by 1
  #
  # @return [Integer] the new answer index
  def answer_index_up
    @answer_index += 1
  end
end
