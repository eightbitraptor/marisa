# frozen_string_literal: true
# 
# {"jsonrpc":"2.0","method":"tools/call","params":{"name":"test_tool"},"id":1}
# {"jsonrpc":"2.0","method":"initialize","id":1}
# {"jsonrpc":"2.0","method":"tools/list","id":1}
require "test_helper"

module Marisa
  module Tools
    class TestGetPersonality < Minitest::Test
      def test_returns_hello_world
        response = GetPersonality.call()

        refute_predicate response, :is_error
      end
    end
  end
end 