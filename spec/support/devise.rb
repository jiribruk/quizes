# frozen_string_literal: true

# Devise test helpers for RSpec
# Provides authentication helpers for controller and request specs
#
# @see https://github.com/heartcombo/devise#test-helpers
RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
end
