# frozen_string_literal: true

require "system/system_test_helper"

module Marisa
  class TestServerCapabilities < Minitest::Test
    include SystemTestHelper

    def test_initialize
      command = {
        jsonrpc: "2.0",
        method: "initialize",
        id: 1,
      }

      response = send_command(command)
      server_info = response.dig("result").dig("serverInfo")
      
      refute_nil server_info
      assert_equal "marisa", server_info.dig("name")
    end

    def test_list_tools
      command = {
        jsonrpc: "2.0",
        method: "tools/list",
        id: 1,
      }

      response = send_command(command)
      tool_list = response.dig("result").dig("tools")
      
      refute_equal 0, tool_list.size
      assert_includes tool_list.map { it["name)"] }, "get_personality"
    end
  end
end 