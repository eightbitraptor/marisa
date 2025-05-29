require_relative "resources/personality"

module Marisa
  module Resources
    def self.resources
      self.constants.each.map do
        self.const_get(_1).new.resource
      end
    end

    def self.resource_handlers
      self.constants.each.map do
        self.const_get(_1).new.handler
      end
    end
  end
end
