# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/index', type: :view do
  let(:quiz1) { build_stubbed(:quiz) }
  let(:quiz2) { build_stubbed(:quiz) }
  let(:quizzes) { [quiz1, quiz2] }

  subject(:rendered) { render }

  before { assign(:quizzes, quizzes) }

  it { is_expected.to have_link(quiz1.name, href: quiz_path(quiz1)) }
  it { is_expected.to have_link(quiz2.name, href: quiz_path(quiz2)) }
end
