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

  # Renders a single quiz as a beautiful card with actions.
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe card with quiz information and actions
  def quiz_card(quiz:)
    tag.div(class: 'card h-100 shadow-sm') do
      tag.div(class: 'card-body d-flex flex-column') do
        safe_join([
                    # Quiz header with visibility badge
                    tag.div(class: 'd-flex justify-content-between align-items-start mb-2') do
                      tag.h5(class: 'card-title mb-0 flex-grow-1') do
                        link_to(quiz.name, quiz_path(quiz), class: 'text-decoration-none text-dark')
                      end +
                      visibility_badge(quiz: quiz)
                    end,

                    # Quiz info
                    tag.div(class: 'mb-3') do
                      safe_join([
                                  tag.small(class: 'text-muted d-block') do
                                    if quiz.user
                                      tag.i(class: 'bi bi-person me-1') +
                                      tag.img(src: quiz.user.gravatar_url(size: 16),
                                              class: 'rounded-circle me-1',
                                              alt: quiz.user.display_name,
                                              style: 'width: 16px; height: 16px;') +
                                      quiz.user.display_name
                                    else
                                      tag.i(class: 'bi bi-person me-1') + t('quiz.no_owner')
                                    end
                                  end,
                                  tag.small(class: 'text-muted d-block') do
                                    tag.i(class: 'bi bi-question-circle me-1') +
                                    t('quiz.questions_count', count: quiz.questions.count)
                                  end
                                ])
                    end,

                    # Actions
                    tag.div(class: 'mt-auto') do
                      tag.div(class: 'd-grid gap-2') do
                        safe_join([
                                    link_to(quiz_path(quiz), class: 'btn btn-outline-primary btn-sm') do
                                      tag.i(class: 'bi bi-play-circle me-1') + t('buttons.start_quiz')
                                    end,
                                    action_buttons(quiz: quiz)
                                  ])
                      end
                    end
                  ])
      end
    end
  end

  # Renders visibility badge for quiz
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe badge
  def visibility_badge(quiz:)
    if quiz.visibility_public?
      tag.span(class: 'badge bg-success') do
        tag.i(class: 'bi bi-globe me-1') + t('quiz.visibility.public')
      end
    else
      tag.span(class: 'badge bg-warning text-dark') do
        tag.i(class: 'bi bi-lock me-1') + t('quiz.visibility.private')
      end
    end
  end

  # Renders action buttons for quiz (edit/delete for owners)
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe action buttons
  def action_buttons(quiz:)
    if current_user && quiz.user == current_user
      tag.div(class: 'd-flex gap-1') do
        safe_join([
                    link_to(edit_quiz_path(quiz), class: 'btn btn-outline-secondary btn-sm flex-fill') do
                      tag.i(class: 'bi bi-pencil')
                    end,
                    button_to(quiz_path(quiz),
                              method: :delete,
                              class: 'btn btn-outline-danger btn-sm flex-fill',
                              data: {
                                turbo_confirm: t('quiz.confirm_delete'),
                                turbo_method: :delete
                              },
                              title: t('buttons.delete_quiz')) do
                      tag.i(class: 'bi bi-trash')
                    end
                  ])
      end
    else
      tag.div(class: 'd-flex gap-1') do
        tag.span(class: 'btn btn-outline-secondary btn-sm flex-fill disabled') do
          tag.i(class: 'bi bi-eye-slash me-1') + t('quiz.read_only')
        end
      end
    end
  end

  # Render a single question title.
  #
  # @param question_text [String]
  # @return [String] HTML safe question block
  def quiz_question_title(question_text:)
    tag.h4(question_text)
  end

  # Renders a single quiz as a list item.
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe list item
  def quizzes_list_item(quiz:)
    tag.li(class: 'list-group-item w-50 mx-auto rounded') do
      link_to(quiz.name, quiz_path(quiz), class: 'text-decoration-none')
    end
  end
end
