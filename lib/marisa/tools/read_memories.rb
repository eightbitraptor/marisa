require_relative '../database'

module Marisa
  module Tools
    class ReadMemories < MCP::Tool
      description "Read memories from the database with optional filtering"

      input_schema(
        properties: {
          memory_type: {
            type: "string",
            enum: ["ephemeral", "core"],
            description: "Filter memories by type (optional)"
          },
          limit: {
            type: "integer",
            minimum: 1,
            maximum: 100,
            default: 100,
            description: "Maximum number of memories to return (default: 10)"
          },
          order: {
            type: "string",
            enum: ["newest", "oldest"],
            default: "newest",
            description: "Order memories by date (default: newest)"
          }
        },
        required: []
      )

      annotations(
        read_only_hint: true,
        destructive_hint: false,
        idempotent_hint: true,
        open_world_hint: false
      )

      def self.call(*args)
        args_hash = args.first
        memory_type = args_hash[:memory_type]
        limit = args_hash[:limit] || 10
        order = args_hash[:order] || "newest"

        sql = "SELECT * FROM memories"
        params = []

        if memory_type
          sql += " WHERE memory_type = ?"
          params << memory_type
        end

        order_clause = order == "oldest" ? "ASC" : "DESC"
        sql += " ORDER BY remembered_at #{order_clause} LIMIT ?"
        params << limit

        begin
          rows = Database.connection.execute(sql, params)
          
          if rows.empty?
            content = [{
              type: "text",
              text: "No memories found."
            }]
          else
            memories_text = rows.map do |row|
              "**Memory ##{row['id']}** (#{row['memory_type']})\n" \
              "Date: #{row['remembered_at']}\n" \
              "Content: #{row['text']}\n"
            end.join("\n---\n\n")

            content = [{
              type: "text", 
              text: "Found #{rows.length} memories:\n\n#{memories_text}"
            }]
          end

          MCP::Tool::Response.new(content)
        rescue SQLite3::Exception => e
          MCP::Tool::Response.new([{
            type: "text",
            text: "Error reading memories: #{e.message}"
          }])
        end
      end
    end
  end
end
