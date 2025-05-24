# frozen_string_literal: true

# ApplicationHelper provides helper methods for views.
#
# @see https://guides.rubyonrails.org/action_view_overview.html
module ApplicationHelper
  def heading(text:)
    tag.h1(text, class: 'mb-4')
  end
end
