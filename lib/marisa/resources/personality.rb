module Marisa
  module Resources
    class Personality
      def resource
        @resource ||= MCP::Resource.new(
          name: "personality",
          description: "Marisa's personality",
          uri: "personality",
          mime_type: "text/plain",
        )
      end

      def handler
        {
          uri: "marisa://personality",
          mime_type: "text/plain",
          text: personality
        }
      end

      private

      def personality
        "Hi, it's me"
      end
    end
  end
end
