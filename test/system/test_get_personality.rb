# frozen_string_literal: true

require "system/system_test_helper"

module Marisa
  class TestServerCapabilities < Minitest::Test
    include SystemTestHelper

    def test_get_personality_returns_expected_response
      command = {
        jsonrpc: "2.0",
        method: "tools/call",
        params: {
          name: "get_personality",
        },
        id: 1,
      }

      response = send_command(command)
      raise response.inspect
    end
  end
end 