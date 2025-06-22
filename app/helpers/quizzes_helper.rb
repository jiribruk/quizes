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

  # Renders a group header for quizzes category as a Bootstrap list-group.
  #
  # @param category_label [String] Název kategorie, defaultně 'others'
  # @return [String] HTML safe list group header
  def quizzes_group_header(category_label: 'others')
    tag.li(class: 'list-unstyled fw-bold text-uppercase mb-1 w-50 mx-auto') do
      tag.h5(t("quiz.category.#{category_label}"))
    end
  end

  # Renders a single quiz as a list-group item with a link.
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe list item with link to quiz show page
  def quizzes_list_item(quiz:)
    tag.li(class: "list-group-item w-50 mx-auto rounded position-relative d-flex align-items-center pe-5") do
      safe_join([
                  link_to(quiz.name, quiz_path(quiz), class: "text-decoration-none text-dark flex-grow-1"),
                  button_to("🧨", quiz_path(quiz),
                            method: :delete,
                            data: { turbo_confirm: t('buttons.confirm.message') },
                            form: { class: "position-absolute end-0 me-3" },
                            class: "btn btn-link p-0 m-0 text-danger fs-4 text-decoration-none",
                            title: t('buttons.destroy')
                  )
                ])
    end
  end

  # Render a single question title.
  #
  # @param question_text [String]
  # @return [String] HTML safe question block
  def quiz_question_title(question_text:)
    tag.h4(question_text)
  end
end
