require_relative '../database'

module Marisa
  module Tools
    class WriteMemories < MCP::Tool
      description "Write a new memory to the database"

      input_schema(
        properties: {
          text: {
            type: "string",
            description: "The content of the memory to store",
            minLength: 1
          },
          memory_type: {
            type: "string",
            enum: ["ephemeral", "core"],
            description: "The type of memory (ephemeral for temporary, core for important)"
          }
        },
        required: ["text", "memory_type"]
      )

      annotations(
        read_only_hint: false,
        destructive_hint: false,
        idempotent_hint: false,
        open_world_hint: false
      )

      def self.call(*args)
        args_hash = args.first
        text = args_hash[:text]
        memory_type = args_hash[:memory_type]

        unless text && !text.strip.empty?
          return MCP::Tool::Response.new([{
            type: "text",
            text: "Error: Memory text cannot be empty."
          }])
        end

        unless ["ephemeral", "core"].include?(memory_type)
          return MCP::Tool::Response.new([{
            type: "text",
            text: "Error: Memory type must be either 'ephemeral' or 'core'."
          }])
        end

        begin
          sql = "INSERT INTO memories (text, memory_type) VALUES (?, ?)"
          Database.connection.execute(sql, [text.strip, memory_type])
          
          memory_id = Database.connection.last_insert_row_id
          
          MCP::Tool::Response.new([{
            type: "text",
            text: "Successfully stored #{memory_type} memory ##{memory_id}: #{text.strip}"
          }])
        rescue SQLite3::Exception => e
          MCP::Tool::Response.new([{
            type: "text",
            text: "Error storing memory: #{e.message}"
          }])
        end
      end
    end
  end
end