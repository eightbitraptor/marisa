module Marisa
  module Tools
    class GetPersonality < MCP::Tool
      description "Get the most up to date version of Marisa"

      class << self
        def call()
          MCP::Tool::Response.new([{
            type: "text",
            text: "Hello World!",
          }])
        rescue => e
          MCP::Tool::Response.new([{
            type: "text",
            text: "Error: #{e.message}",
          }])
        end
      end
    end
  end
end