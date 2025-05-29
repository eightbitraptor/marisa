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

    def test_tools
      command = {
        jsonrpc: "2.0",
        method: "tools/list",
        id: 1,
      }

      response = send_command(command)
      tools = response.dig("result").dig("tools")

      assert_equal 3, tools.length
      tool_names = tools.map { |t| t.dig("name") }
      assert_includes tool_names, "personality"
      assert_includes tool_names, "read_memories" 
      assert_includes tool_names, "write_memories"
    end

    def test_personality
      command = {
        jsonrpc: "2.0",
        method: "tools/call",
        params: {
          name: "personality",
          arguments: {}
        },
        id: 1,
      }

      response = send_command(command)
      content = response.dig("result").dig("content")

      assert_equal 1, content.length
      assert_equal "text", content.first["type"]
      refute_equal 0, content.first["text"].length
    end

    def test_write_memory
      command = {
        jsonrpc: "2.0",
        method: "tools/call",
        params: {
          name: "write_memories",
          arguments: {
            text: "Test memory for integration testing",
            memory_type: "ephemeral"
          }
        },
        id: 1,
      }

      response = send_command(command)
      content = response.dig("result").dig("content")

      assert_equal 1, content.length
      assert_equal "text", content.first["type"]
      assert_includes content.first["text"], "Successfully stored ephemeral memory"
    end

    def test_read_memories
      command = {
        jsonrpc: "2.0",
        method: "tools/call",
        params: {
          name: "read_memories",
          arguments: {
            limit: 5
          }
        },
        id: 1,
      }

      response = send_command(command)
      content = response.dig("result").dig("content")

      assert_equal 1, content.length
      assert_equal "text", content.first["type"]
      # Should either show "No memories found" or actual memories starting with "Found"
      text_start = content.first["text"].split(" ").first(2).join(" ")
      assert_includes ["No memories", "Found 0", "Found 1", "Found 2", "Found 3", "Found 4", "Found 5"], text_start
    end
  end
end 
