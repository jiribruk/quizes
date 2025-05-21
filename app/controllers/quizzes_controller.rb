# frozen_string_literal: true

class QuizzesController < ApplicationController

  def index
    @quizzes = Quiz.all
  end

  def show
    quiz
  end

  private

  def quiz
   @quiz ||= Quiz.find(params[:id])
  end
end
