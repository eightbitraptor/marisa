require_relative 'tools/personality'
require_relative 'tools/read_memories'
require_relative 'tools/write_memories'

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
