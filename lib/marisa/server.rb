require_relative 'tools'

module Marisa
  class Server
    def self.run
      server = MCP::Server.new(
        name: "marisa", 
        server_context: {},
        tools: [
          Marisa::Tools::Personality,
          Marisa::Tools::ReadMemories,
          Marisa::Tools::WriteMemories
        ]
      )

      transport = MCP::Transports::StdioTransport.new(server)

      transport.open
    end
  end
end
