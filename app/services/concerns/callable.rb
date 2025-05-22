# frozen_string_literal: true

# Provides a simple interface to call service objects via `.call`.
# Example: `MyService.call(args)`
module Callable
  extend ActiveSupport::Concern

  class_methods do
    def call(...)
      new(...).call
    end
  end
end
