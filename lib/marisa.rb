# frozen_string_literal: true

require 'model_context_protocol'
require 'model_context_protocol/transports/stdio'

require_relative "marisa/version"
require_relative "marisa/database"
require_relative "marisa/tools"
require_relative "marisa/server"

module Marisa
  class Error < StandardError; end
end
