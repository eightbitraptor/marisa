# frozen_string_literal: true

require 'model_context_protocol'
require 'model_context_protocol/transports/stdio'

require_relative "marisa/version"
require_relative "marisa/resources"
require_relative "marisa/server"

module Marisa
  class Error < StandardError; end
end
