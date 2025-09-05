# frozen_string_literal: true

# Base controller for all application controllers.
# Handles global controller behavior, error handling and authentication.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class ApplicationController < ActionController::Base
  # Require authentication for all actions
  before_action :authenticate_user!

  # Configure permitted parameters for Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Configure permitted parameters for Devise controllers
  #
  # @return [void]
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password])
  end
end
