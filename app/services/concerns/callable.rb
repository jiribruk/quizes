# frozen_string_literal: true

# Provides a simple interface to call service objects via `.call`.
# Allows service objects to be called directly without instantiation.
#
# @example
#   class MyService
#     include Callable
#
#     def initialize(param1:, param2:)
#       @param1 = param1
#       @param2 = param2
#     end
#
#     def call
#       # service logic here
#     end
#   end
#
#   # Usage:
#   result = MyService.call(param1: "value1", param2: "value2")
#
module Callable
  extend ActiveSupport::Concern

  class_methods do
    # Creates a new instance of the service and calls it immediately
    #
    # @param args [Hash] arguments to pass to the service constructor
    # @return [Object] the result of calling the service
    def call(...)
      new(...).call
    end
  end
end
