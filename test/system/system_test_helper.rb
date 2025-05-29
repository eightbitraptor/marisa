# frozen_string_literal: true

require "test_helper"
require "json"

module SystemTestHelper
  def setup
    start_server
    super
  end

  def teardown
    stop_server
    super
  end

  private

  def start_server
    @server = MCP::Server.new(
      name: "marisa", 
      server_context: {},
      tools: [
        Marisa::Tools::Personality,
        Marisa::Tools::ReadMemories,
        Marisa::Tools::WriteMemories
      ]
    )
  end

  def stop_server
    @server = nil
  end

  def send_command(command)
    json_request = command.to_json
    json_response = @server.handle_json(json_request)
    JSON.parse(json_response)
  rescue JSON::ParserError
    # If we got a non-JSON response, return it as-is
    { "error" => json_response }
  end
end 
