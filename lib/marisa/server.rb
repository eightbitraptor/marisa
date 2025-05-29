module Marisa
  class Server
    def self.run

      server = MCP::Server.new(
        name: "marisa", 
        server_context: {},
        resources: Marisa::Resources.resources
      )

      server.resources_read_handler do 
        Marisa::Resources.resource_handlers
      end

      transport = MCP::Transports::StdioTransport.new(server)

      transport.open
    end
  end
end
