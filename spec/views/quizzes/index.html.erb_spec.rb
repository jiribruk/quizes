# frozen_string_literal: true

require 'rails_helper'

describe 'quizzes/index', type: :view do
  let(:quiz1) { build_stubbed(:quiz) }
  let(:quiz2) { build_stubbed(:quiz) }
  let(:quizzes) { [quiz1, quiz2] }

  before do
    assign(:quizzes, quizzes)
    render
  end

  it 'displays the name of each quiz' do
    expect(rendered).to have_link(quiz1.name, href: quiz_path(quiz1))
    expect(rendered).to have_link(quiz2.name, href: quiz_path(quiz2))
  end
end
