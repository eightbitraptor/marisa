#!/usr/bin/env ruby
require 'bundler/setup'

require "model_context_protocol"
require "model_context_protocol/transports/stdio"

class TestTool < MCP::Tool
  description "A simple example tool that adds two numbers"

  class << self
    def call(*args, server_context:)
      binding.b
      MCP::Tool::Response.new([{
        type: "text",
        text: "Hi"
      }])
    end
  end
end

@server = MCP::Server.new(name: "test", tools: [TestTool])
@transport = MCP::Transports::StdioTransport.new(@server)

@transport.open


