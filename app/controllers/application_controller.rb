# frozen_string_literal: true

class ApplicationController < ActionController::Base

  rescue_from(::ActiveRecord::RecordNotFound) { |exception| render_404(exception) }


  def render_404(exception)
    render plain: exception.message, status: 404
  end

end
