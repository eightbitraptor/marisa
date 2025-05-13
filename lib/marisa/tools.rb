# frozen_string_literal: true

require_relative 'tools/get_personality'

module Marisa
  def self.tools
    [Tools::GetPersonality]
  end
end
