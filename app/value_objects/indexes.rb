# frozen_string_literal: true

class Indexes

  attr_reader :question_index, :answer_index

  def initialize(question_index: 0, answer_index: 0)
    @question_index = question_index
    @answer_index = answer_index
  end

  def question_index_up
    @question_index = @question_index + 1
  end

  def answer_index_up
    @answer_index = @answer_index + 1
  end

end
