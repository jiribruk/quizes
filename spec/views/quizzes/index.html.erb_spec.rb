# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/index', type: :view do
  let(:quiz1) { create(:quiz, category: 'movies') }
  let(:quiz2) { create(:quiz, category: 'companies') }
  let(:quizzes) { [quiz1, quiz2] }

  subject(:rendered) { render }

  before { assign(:grouped_quizzes, { 'movies' => [quiz1], 'companies' => [quiz2] }) }

  it { is_expected.to have_selector('h1', text: I18n.t('quiz.index.title')) }
  it { is_expected.to have_selector('h5', text: I18n.t('quiz.category.movies')) }
  it { is_expected.to have_selector('h5', text: I18n.t('quiz.category.companies')) }
  it { is_expected.to have_link(quiz1.name, href: quiz_path(quiz1)) }
  it { is_expected.to have_link(quiz2.name, href: quiz_path(quiz2)) }
end
