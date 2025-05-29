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

    def test_resources
      command = {
        jsonrpc: "2.0",
        method: "resources/list",
        id: 1,
      }

      response = send_command(command)
      resources = response.dig("result").dig("resources")

      assert_equal 1, resources.length
      assert_equal "personality", resources.first.dig("name")
    end

    def test_personality
      command = {
        jsonrpc: "2.0",
        method: "resources/read",
        params: {
          uri: "marisa://personality"
        },
        id: 1,
      }

      response = send_command(command)
      contents = response.dig("result").dig("contents")

      assert_equal 1, contents.length
      assert_equal "marisa://personality", contents.first["uri"]
      refute_equal 0, contents.first["text"].length
    end
  end
end 
