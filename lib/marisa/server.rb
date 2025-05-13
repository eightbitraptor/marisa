module Marisa
  class Server
    def self.run
      @tool = MCP::Tool.define(name: "test_tool", description: "Test tool")

      server = MCP::Server.new(name: "marisa", tools: [@tool])
      transport = MCP::Transports::StdioTransport.new(server)

      transport.open
    end
  end
end
