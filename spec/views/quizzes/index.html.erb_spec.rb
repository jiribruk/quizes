# frozen_string_literal: true

require 'rails_helper'

# View specs for quizzes index page
# Tests the display of quizzes grouped by category
#
# @see QuizzesController#index
describe 'quizzes/index', type: :view do
  # Creates test quizzes with different categories
  let(:quiz1) { create(:quiz, category: 'movies') }
  let(:quiz2) { create(:quiz, category: 'companies') }
  let(:quizzes) { [quiz1, quiz2] }

  # Subject for testing the rendered view
  subject(:rendered) { render }

  # Assigns grouped quizzes to the view instance variable
  before { assign(:grouped_quizzes, { 'movies' => [quiz1], 'companies' => [quiz2] }) }

  # Tests that the page displays the correct title and category headers
  it { is_expected.to have_selector('h1', text: I18n.t('quiz.index.title')) }
  it { is_expected.to have_selector('h5', text: I18n.t('quiz.category.movies')) }
  it { is_expected.to have_selector('h5', text: I18n.t('quiz.category.companies')) }
  # Tests that quiz names are displayed as links to their show pages
  it { is_expected.to have_link(quiz1.name, href: quiz_path(quiz1)) }
  it { is_expected.to have_link(quiz2.name, href: quiz_path(quiz2)) }
end
