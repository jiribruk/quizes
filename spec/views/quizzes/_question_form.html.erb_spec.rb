# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/_question', type: :view do
  let(:question) { build_stubbed(:question, text: 'Sample question', answers: [answer]) }
  let(:answer) { build_stubbed(:answer, text: 'Answer text') }
  let(:question_index) { 0 }
  let(:answer_index) { 0 }

  before do
    allow(question).to receive(:image).and_return(double(attached?: false))
  end

  subject(:rendered) do
    render partial: 'quizzes/question_form', locals: {
      question: question,
      question_index: question_index,
      answer_index: answer_index
    }
  end

  it { is_expected.to have_selector("div#question_id_#{question_index}.question-item") }
  it { is_expected.to include(I18n.t('titles.question_number', number: question_index + 1)) }
  it { is_expected.to have_selector("label[for='quiz_questions_attributes_#{question_index}_text']", text: I18n.t('labels.question_text')) }
  it { is_expected.to have_selector("textarea[name='quiz[questions_attributes][#{question_index}][text]']", text: question.text) }
  it { is_expected.to have_selector("label[for='quiz_questions_attributes_#{question_index}_image']", text: I18n.t('labels.question_image')) }
  it { is_expected.to have_selector("input[type='file'][name='quiz[questions_attributes][#{question_index}][image]']") }
  it { is_expected.to have_selector("img.img-thumbnail.d-none[data-quizzes-target='preview']") }
  it { is_expected.to have_selector("input[type='hidden'][name='quiz[questions_attributes][#{question_index}][_destroy]']", visible: false) }
  it { is_expected.to have_selector("button.remove-question-btn[data-action='quizzes#remove']") }
  it {
    is_expected.to have_link(
      I18n.t('buttons.add_answer'),
      href: add_answer_quizzes_path(question_index: question_index, answer_index: answer_index)
    )
  }
  it { is_expected.to have_selector("div#answers-container-for-question#{question_index}") }

  it 'renders the answers partial for each answer' do
    expect(view).to render_template(partial: 'quizzes/_answer_form')
  end
end
