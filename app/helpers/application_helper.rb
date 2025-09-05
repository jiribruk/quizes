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
            tag.div(class: 'navbar-nav align-items-center') do
              tag.div(class: 'd-flex align-items-center me-3') do
                tag.img(src: current_user.gravatar_url(size: 32), 
                        class: 'rounded-circle me-2', 
                        alt: current_user.display_name,
                        style: 'width: 32px; height: 32px;',
                        title: t('users.navbar.signed_in_as', name: current_user.display_name))
              end +
              tag.div(class: 'd-flex') do
                tag.a(t('users.navbar.edit_profile'), class: 'btn btn-outline-dark btn-sm me-2', 
                      href: edit_user_registration_path) +
                tag.a(t('devise.sessions.signed_out'), class: 'btn btn-outline-dark btn-sm', 
                      href: destroy_user_session_path, 
                      data: { turbo_method: :delete, 
                              turbo_confirm: t('users.navbar.confirm_sign_out') })
              end
            end
          else
            tag.div(class: 'd-flex') do
              tag.a(t('devise.shared.links.sign_in'), class: 'btn btn-outline-dark btn-sm me-2', 
                    href: new_user_session_path) +
              tag.a(t('devise.shared.links.sign_up'), class: 'btn btn-dark btn-sm', 
                    href: new_user_registration_path)
            end
          end
        end
      end
    end
  end
end
