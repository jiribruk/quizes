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

  # Renders a single quiz as a beautiful card with actions.
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe card with quiz information and actions
  def quiz_card(quiz:)
    tag.div(class: quiz_card_performance_classes(quiz: quiz, user: current_user)) do
      tag.div(class: 'card-body d-flex flex-column') do
        safe_join([
                    quiz_card_header(quiz: quiz),
                    quiz_card_info(quiz: quiz),
                    quiz_performance_indicator(quiz: quiz, user: current_user),
                    quiz_card_actions(quiz: quiz)
                  ])
      end
    end
  end

  # Renders quiz card header with title and visibility badge
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe header
  def quiz_card_header(quiz:)
    tag.div(class: 'd-flex justify-content-between align-items-start mb-2') do
      quiz_card_title(quiz: quiz) + quiz_visibility_badge(quiz: quiz)
    end
  end

  # Renders quiz card title as a link
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe title link
  def quiz_card_title(quiz:)
    tag.h5(class: 'card-title mb-0 flex-grow-1') do
      link_to(quiz.name, quiz_path(quiz), class: 'text-decoration-none text-dark')
    end
  end

  # Renders visibility badge for quiz
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe badge
  def quiz_visibility_badge(quiz:)
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

  # Renders quiz card info section with owner and questions count
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe info section
  def quiz_card_info(quiz:)
    tag.div(class: 'mb-3') do
      safe_join([
                  quiz_owner_info(quiz: quiz),
                  quiz_questions_count(quiz: quiz)
                ])
    end
  end

  # Renders quiz owner information
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe owner info
  def quiz_owner_info(quiz:)
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
    end
  end

  # Renders quiz questions count
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe questions count
  def quiz_questions_count(quiz:)
    tag.small(class: 'text-muted d-block') do
      tag.i(class: 'bi bi-question-circle me-1') +
        t('quiz.questions_count', count: quiz.questions.count)
    end
  end

  # Renders quiz card actions section
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe actions section
  def quiz_card_actions(quiz:)
    tag.div(class: 'mt-auto') do
      tag.div(class: 'd-grid gap-2') do
        safe_join([
                    quiz_start_button(quiz: quiz),
                    quiz_management_buttons(quiz: quiz)
                  ])
      end
    end
  end

  # Renders quiz start button
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe start button
  def quiz_start_button(quiz:)
    link_to(quiz_path(quiz), class: 'btn btn-outline-primary btn-sm') do
      tag.i(class: 'bi bi-play-circle me-1') + t('buttons.start_quiz')
    end
  end

  # Renders quiz management buttons (edit/delete for owners, read-only for others)
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe management buttons
  def quiz_management_buttons(quiz:)
    if current_user && quiz.user == current_user
      quiz_owner_buttons(quiz: quiz)
    else
      quiz_read_only_button
    end
  end

  # Renders edit and delete buttons for quiz owner
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe owner buttons
  def quiz_owner_buttons(quiz:)
    tag.div(class: 'd-flex gap-1') do
      safe_join([
                  quiz_edit_button(quiz: quiz),
                  quiz_delete_button(quiz: quiz)
                ])
    end
  end

  # Renders quiz edit button
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe edit button
  def quiz_edit_button(quiz:)
    link_to(edit_quiz_path(quiz), class: 'btn btn-outline-secondary btn-sm flex-fill') do
      tag.i(class: 'bi bi-pencil')
    end
  end

  # Renders quiz delete button
  #
  # @param quiz [Quiz]
  # @return [String] HTML safe delete button
  def quiz_delete_button(quiz:)
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
  end

  # Renders read-only button for non-owners
  #
  # @return [String] HTML safe read-only button
  def quiz_read_only_button
    tag.div(class: 'd-flex gap-1') do
      tag.span(class: 'btn btn-outline-secondary btn-sm flex-fill disabled') do
        tag.i(class: 'bi bi-eye-slash me-1') + t('quiz.read_only')
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

  # Returns CSS classes for quiz card based on user's performance
  #
  # @param quiz [Quiz] the quiz to get performance for
  # @param user [User, nil] the user to check performance for
  # @return [String] CSS classes for the quiz card
  def quiz_card_performance_classes(quiz:, user:)
    return 'card h-100 shadow-sm' unless user

    performance_level = quiz.performance_level_for_user(user)
    base_classes = 'card h-100 shadow-sm'

    case performance_level
    when :green
      "#{base_classes} border-success"
    when :yellow
      "#{base_classes} border-warning"
    when :red
      "#{base_classes} border-danger"
    else
      base_classes
    end
  end

  # Returns performance indicator for quiz card
  #
  # @param quiz [Quiz] the quiz to get performance for
  # @param user [User, nil] the user to check performance for
  # @return [String] HTML safe performance indicator
  def quiz_performance_indicator(quiz:, user:)
    return '' unless user

    best_result = quiz.best_result_for_user(user)
    return '' unless best_result

    tag.small(class: 'text-muted d-block') do
      tag.i(class: performance_icon_class(best_result.performance_level),
            title: performance_tooltip(best_result)) +
        " #{best_result.percentage}% (#{best_result.score}/#{best_result.questions_count})"
    end
  end

  # Returns icon class for performance level
  #
  # @param performance_level [Symbol] :green, :yellow, :red
  # @return [String] Bootstrap icon class
  def performance_icon_class(performance_level)
    case performance_level
    when :green
      'bi bi-check-circle-fill text-success me-1'
    when :yellow
      'bi bi-exclamation-triangle-fill text-warning me-1'
    when :red
      'bi bi-x-circle-fill text-danger me-1'
    else
      'bi bi-question-circle me-1'
    end
  end

  # Returns tooltip text for performance level
  #
  # @param result [QuizResultHistory] the result to get tooltip for
  # @return [String] tooltip text
  def performance_tooltip(result)
    case result.performance_level
    when :green
      "Výborně! #{result.percentage}% - #{result.completed_at.strftime('%d.%m.%Y')}"
    when :yellow
      "Dobře! #{result.percentage}% - #{result.completed_at.strftime('%d.%m.%Y')}"
    when :red
      "Zkus to znovu! #{result.percentage}% - #{result.completed_at.strftime('%d.%m.%Y')}"
    else
      "#{result.percentage}% - #{result.completed_at.strftime('%d.%m.%Y')}"
    end
  end
end
