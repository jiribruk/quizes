# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Quiz Evaluation', type: :feature do
  describe 'User takes a quiz and sees results' do
    let(:quiz) { create(:quiz, name: 'Math Quiz', category: 'Mathematics') }

    let!(:question1) do
      create(:question, quiz: quiz, text: 'What is 2+2?', answers: [
               answer_one_one,
               answer_one_two,
               answer_one_three
             ])
    end

    let!(:question2) do
      create(:question, quiz: quiz, text: 'What is 3x3?', answers: [
               answer_two_one,
               answer_two_two,
               answer_two_three
             ])
    end

    let!(:question3) do
      create(:question, quiz: quiz, text: 'What is 10-5?', answers: [
               answer_three_one,
               answer_three_two,
               answer_three_three
             ])
    end

    # Question 1 answers
    let(:answer_one_one) { build(:answer, text: '3', correct: false) }
    let(:answer_one_two) { build(:answer, text: '4', correct: true) } # correct answer for question 1
    let(:answer_one_three) { build(:answer, text: '5', correct: false) }

    # Question 2 answers
    let(:answer_two_one) { build(:answer, text: '6', correct: false) }
    let(:answer_two_two) { build(:answer, text: '9', correct: true) } # correct answer for question 2
    let(:answer_two_three) { build(:answer, text: '12', correct: false) }

    # Question 3 answers
    let(:answer_three_one) { build(:answer, text: '3', correct: false) } # incorrect answer for question 3
    let(:answer_three_two) { build(:answer, text: '5', correct: true) }
    let(:answer_three_three) { build(:answer, text: '7', correct: false) }

    # Sign in user before each test
    before do
      login_with_warden!
    end

    scenario 'user selects a quiz, answers questions, and sees evaluation results' do
      # When: User visits the quiz overview page
      visit quizzes_path

      # Then: User sees the quiz in the list
      expect(page).to have_content('Math Quiz')
      expect(page).to have_content('Mathematics') # Category is displayed with first letter uppercase

      # When: User clicks on the quiz to take it
      click_link 'Math Quiz'

      # Then: User sees the quiz with all 3 questions
      expect(page).to have_content('Math Quiz')
      expect(page).to have_content('What is 2+2?')
      expect(page).to have_content('What is 3x3?')
      expect(page).to have_content('What is 10-5?')

      # And: User sees all answer options for each question
      expect(page).to have_content('3')
      expect(page).to have_content('4')
      expect(page).to have_content('5')
      expect(page).to have_content('6')
      expect(page).to have_content('9')
      expect(page).to have_content('12')
      expect(page).to have_content('7')

      # When: User selects answers (2 correct, 1 incorrect)
      # Question 1: Correct answer (4)
      choose "answer_#{answer_one_two.id}"
      # Question 2: Correct answer (9)
      choose "answer_#{answer_two_two.id}"
      # Question 3: Incorrect answer (3 instead of 5)
      choose "answer_#{answer_three_one.id}"

      # And: User clicks on evaluation button
      click_button I18n.t('buttons.submit')

      # Then: User should see evaluation results
      # The form submits to the evaluation endpoint
      expect(page).to have_current_path(evaluation_quiz_path(quiz))
    end
  end
end
