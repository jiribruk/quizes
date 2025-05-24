# frozen_string_literal: true

# ApplicationHelper provides helper methods for views.
#
# @see https://guides.rubyonrails.org/action_view_overview.html
module ApplicationHelper
  def title(text:)
    tag.h1(text, class: 'mb-4')
  end

  # Renders the top Bootstrap navbar with a Home link.
  # @return [String] HTML safe navbar
  def top_navbar
    tag.nav(class: 'navbar border-bottom', style: 'background-color: #FFA500;') do
      tag.div(class: 'container-fluid') do
        tag.a(class: 'navbar-brand', href: root_path) do
          t('buttons.home')
        end
      end
    end
  end
end
