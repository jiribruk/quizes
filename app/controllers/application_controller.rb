# ApplicationController is the base controller for all controllers in the application.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class ApplicationController < ActionController::Base
  rescue_from(::ActiveRecord::RecordNotFound) { |exception| render_404(exception) }

  # Renders a 404 error page with the exception message.
  #
  # @param exception [ActiveRecord::RecordNotFound] the exception that was raised
  # @return [void]
  def render_404(exception)
    render plain: exception.message, status: :not_found
  end

end
