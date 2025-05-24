# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'quizzes/index', type: :view do
  let(:quiz1) { build_stubbed(:quiz) }
  let(:quiz2) { build_stubbed(:quiz) }
  let(:quizzes) { [quiz1, quiz2] }

  before do
    assign(:quizzes, quizzes)
    render
  end

  it 'displays the name of each quiz' do
    expect(rendered).to include(quiz1.name)
    expect(rendered).to include(quiz2.name)
  end
end
