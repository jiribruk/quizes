# frozen_string_literal: true

# QuizzesHelper provides view helpers for quizzes.
module QuizzesHelper
  # Render a score title with animation.
  #
  # @param score [Integer]
  # @param questions_count [Integer]
  # @return [String] HTML safe score title
  def score_title(score:, questions_count:)
    tag.h1(t('quiz.score', score:, questions_count:),
           id: 'score_title',
           class: 'mb-4 w-50 mx-auto animated_score_title')
  end

  # Renders a list of quizzes as Bootstrap list-group with links.
  #
  # @param quizzes [Enumerable<Quiz>] List of quizzes to render
  # @return [String] HTML safe list of quizzes
  def quizzes_list(quizzes:)
    tag.ul(class: 'list-group') do
      quizzes.map { |quiz| quizzes_list_item(quiz:) }.join.html_safe
    end
  end

  # Renders a single quiz as a list-group item with a link.
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe list item with link to quiz show page
  def quizzes_list_item(quiz:)
    tag.li(class: 'list-group-item w-50 mx-auto rounded') do
      link_to quiz.name, quiz_path(quiz)
    end
  end

  # Render a single question title.
  #
  # @param question_text [String]
  # @return [String] HTML safe question block
  def quiz_question_title(question_text:)
    tag.h4(question_text)
  end

  # Render a single answer item with radio button and label.
  #
  # @param question [Question]
  # @param answer [Answer]
  # @param form [ActionView::Helpers::FormBuilder]
  # @return [String] HTML safe answer item
  def quiz_answer_item(question:, answer:, form:)
    tag.li(class: 'list-group-item w-25 mx-auto rounded d-flex justify-content-between') do
      s = form.radio_button("answers[#{question.id}]", answer.id, id: "answer_#{answer.id}")
      s += form.label("answer_#{answer.id}", answer.text)
      s += tag.span('', id: "answer_#{answer.id}_marker")
      s
    end
  end

  # Render a submit button with Stimulus controller.
  #
  # @param form [ActionView::Helpers::FormBuilder]
  # @return [String] HTML safe submit button
  def quiz_submit_button(form:)
    form.submit t('buttons.submit'),
                class: 'btn btn-primary mb-3',
                id: 'submit_button',
                data: { controller: 'quizzes', 'quizzes-target': 'submit' }
  end
end
