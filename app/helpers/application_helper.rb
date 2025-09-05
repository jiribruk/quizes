# frozen_string_literal: true

# ApplicationHelper provides helper methods for views.
#
# @see https://guides.rubyonrails.org/action_view_overview.html
module ApplicationHelper
  def title(text:)
    tag.h1(text, class: 'mb-4')
  end

  # Renders the top Bootstrap navbar with navigation links and user authentication.
  # @return [String] HTML safe navbar
  def top_navbar
    tag.nav(class: 'navbar fixed-top border-bottom', style: 'background-color: #FFA500;') do
      tag.div(class: 'container-fluid') do
        tag.a(class: 'navbar-brand', href: root_path) do
          t('buttons.home')
        end +
        tag.div(class: 'navbar-nav ms-auto') do
          if user_signed_in?
            tag.span(class: 'navbar-text me-3') do
              "Přihlášen jako: #{current_user.email}"
            end +
            tag.a('Odhlásit se', class: 'btn btn-outline-dark btn-sm', 
                  href: destroy_user_session_path, 
                  data: { turbo_method: :delete, 
                          turbo_confirm: 'Opravdu se chcete odhlásit?' })
          else
            tag.a('Přihlásit se', class: 'btn btn-outline-dark btn-sm me-2', 
                  href: new_user_session_path) +
            tag.a('Registrace', class: 'btn btn-dark btn-sm', 
                  href: new_user_registration_path)
          end
        end
      end
    end
  end
end
