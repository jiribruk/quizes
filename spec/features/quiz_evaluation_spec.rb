# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Quiz Evaluation', type: :feature do
  describe 'User takes a quiz and sees results' do
    let(:quiz) { create(:quiz, name: 'Math Quiz', category: 'Mathematics') }

    let!(:question1) do
      create(:question, quiz: quiz, text: 'What is 2+2?', answers: [
               answer1_1,
               answer1_2,
               answer1_3
             ])
    end

    let!(:question2) do
      create(:question, quiz: quiz, text: 'What is 3x3?', answers: [
               answer2_1,
               answer2_2,
               answer2_3
             ])
    end

    let!(:question3) do
      create(:question, quiz: quiz, text: 'What is 10-5?', answers: [
               answer3_1,
               answer3_2,
               answer3_3
             ])
    end

    # Question 1 answers
    let(:answer1_1) { build(:answer, text: '3', correct: false) }
    let(:answer1_2) { build(:answer, text: '4', correct: true) } # correct answer for question 1
    let(:answer1_3) { build(:answer, text: '5', correct: false) }

    # Question 2 answers
    let(:answer2_1) { build(:answer, text: '6', correct: false) }
    let(:answer2_2) { build(:answer, text: '9', correct: true) } # correct answer for question 2
    let(:answer2_3) { build(:answer, text: '12', correct: false) }

    # Question 3 answers
    let(:answer3_1) { build(:answer, text: '3', correct: false) } # incorrect answer for question 3
    let(:answer3_2) { build(:answer, text: '5', correct: true) }
    let(:answer3_3) { build(:answer, text: '7', correct: false) }

    scenario 'user selects a quiz, answers questions, and sees evaluation results', js: true do
      # When: User visits the quiz overview page
      visit quizzes_path

      # Then: User sees the quiz in the list
      expect(page).to have_content('Math Quiz')
      expect(page).to have_content('MATHEMATICS') # Category is displayed in uppercase

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
      choose "answer_#{answer1_2.id}"
      # Question 2: Correct answer (9)
      choose "answer_#{answer2_2.id}"
      # Question 3: Incorrect answer (3 instead of 5)
      choose "answer_#{answer3_1.id}"

      # And: User clicks on evaluation button
      click_button I18n.t('buttons.submit')

      # Then: User sees the score display
      expect(page).to have_content(I18n.t('quiz.score', score: 2, questions_count: 3))

      # And: User sees checkmarks (✅) for correct answers
      expect(page).to have_css("span[id='answer_#{answer1_2.id}_marker']")
      expect(page).to have_css("span[id='answer_#{answer2_2.id}_marker']")
      expect(page).to have_content('✅')

      # And: User sees crosses (❌) for incorrect answers
      expect(page).to have_css("span[id='answer_#{answer3_1.id}_marker']")
      expect(page).to have_content('❌')

      # And: Submit button is removed after evaluation
      expect(page).not_to have_button(I18n.t('buttons.submit'))
    end
  end
end
