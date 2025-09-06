# frozen_string_literal: true

# ApplicationHelper provides helper methods for views.
#
# @see https://guides.rubyonrails.org/action_view_overview.html
module ApplicationHelper
  # Renders the top Bootstrap navbar with navigation links and user authentication.
  # @return [String] HTML safe navbar
  def top_navbar
    tag.nav(class: 'navbar fixed-top border-bottom', style: 'background-color: #FFA500;') do
      tag.div(class: 'container-fluid') do
        # Left side - Home, New Quiz and My Groups buttons
        tag.div(class: 'd-flex align-items-center') do
          tag.a(t('buttons.home'), class: 'btn btn-sm me-3 navbar-btn', href: root_path) +
            (if user_signed_in?
               tag.a(t('buttons.new_quiz'), class: 'btn btn-sm me-3 navbar-btn', href: new_quiz_path) +
                           tag.a(t('user_groups.index.title'), class: 'btn btn-sm me-3 navbar-btn', href: user_groups_path)
             else
               ''
             end)
        end +
          # Right side - User controls
          tag.div(class: 'navbar-nav ms-auto') do
            if user_signed_in?
              tag.div(class: 'd-flex align-items-center') do
                tag.img(src: current_user.gravatar_url(size: 48),
                        class: 'rounded-circle me-2 navbar-gravatar',
                        alt: current_user.display_name,
                        style: 'width: 48px; height: 48px;',
                        title: t('users.navbar.signed_in_as', name: current_user.display_name)) +
                  tag.a(t('users.navbar.edit_profile'), class: 'btn btn-sm me-2 navbar-btn',
                                                        href: edit_user_registration_path) +
                  tag.a(t('devise.sessions.signed_out'), class: 'btn btn-sm navbar-btn-logout',
                                                         href: destroy_user_session_path,
                                                         data: { turbo_method: :delete,
                                                                 turbo_confirm: t('users.navbar.confirm_sign_out') })
              end
            else
              tag.div(class: 'd-flex') do
                tag.a(t('devise.shared.links.sign_in'), class: 'btn btn-sm me-2 navbar-btn',
                                                        href: new_user_session_path) +
                  tag.a(t('devise.shared.links.sign_up'), class: 'btn btn-sm navbar-btn-signup',
                                                          href: new_user_registration_path)
              end
            end
          end
      end
    end
  end
end
