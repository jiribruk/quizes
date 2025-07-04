# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/_answer_form', type: :view do
  let(:answer) { build_stubbed(:answer, text: 'Answer text', correct: true, id: 42) }
  let(:question_index) { 0 }
  let(:answer_index) { 1 }

  subject(:rendered) do
    render partial: 'quizzes/answer_form', locals: {
      answer: answer,
      question_index: question_index,
      answer_index: answer_index
    }
  end

  it { is_expected.to have_selector("div.answer-item.border.rounded.p-2.mb-2[data-controller='quizzes']") }

  it 'renders text field with correct name and value' do
    is_expected.to have_selector("input.form-control[type='text'][name='quiz[questions_attributes][#{question_index}][answers_attributes][#{answer_index}][text]'][value='#{answer.text}']")
  end

  it 'renders checkbox for correct answer with correct checked status' do
    is_expected.to have_selector("input.form-check-input[type='checkbox'][name='quiz[questions_attributes][#{question_index}][answers_attributes][#{answer_index}][correct]'][checked]")
  end

  it 'renders label for correct answer checkbox' do
    is_expected.to have_selector("label.form-check-label[for='quiz_questions_attributes_#{question_index}_answers_attributes_#{answer_index}_correct']", text: I18n.t('labels.correct_answer'))
  end

  it 'renders hidden field for answer id if persisted' do
    is_expected.to have_selector("input[type='hidden'][name='quiz[questions_attributes][#{question_index}][answers_attributes][#{answer_index}][id]'][value='#{answer.id}']", visible: false)
  end

  it 'renders remove answer button with Stimulus action' do
    is_expected.to have_selector("button.remove-answer-btn.btn.btn-outline-danger.btn-sm[data-action='quizzes#remove']")
  end

  it 'renders hidden _destroy field with proper data attribute' do
    is_expected.to have_selector(
      "input[type='hidden'][name='quiz[questions_attributes][#{question_index}][answers_attributes][#{answer_index}][_destroy]'][value='false'][data-quizzes-target='destroyField']", visible: false
    )
  end
end
