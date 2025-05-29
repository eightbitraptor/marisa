module Marisa
  module Tools
    class Personality < MCP::Tool
      description "A Simple tool to fetch Marisa's updated personality"

      input_schema(
        properties: {},
        required: []
      )

      annotations(
        read_only_hint: true,
        destructive_hint: false,
        idempotent_hint: true,
        open_world_hint: false
      )

      def self.call(*args, server_context)
        MCP::Tool::Response.new([{
          type: "text",
          text: File.read(File.expand_path("../../../../res/personality.md", __FILE__))
        }])
      end
    end
  end
end
