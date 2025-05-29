require 'sqlite3'
require 'fileutils'

module Marisa
  class Database
    class << self
      def connection
        @connection ||= begin
          ensure_database_directory
          db = SQLite3::Database.new(database_path)
          db.results_as_hash = true
          initialize_schema(db)
          db
        end
      end

      def close
        @connection&.close
        @connection = nil
      end

      private

      def database_path
        @database_path ||= File.expand_path("~/.marisa/memories.db")
      end

      def ensure_database_directory
        dir = File.dirname(database_path)
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      end

      def initialize_schema(db)
        db.execute <<~SQL
          CREATE TABLE IF NOT EXISTS memories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT NOT NULL,
            remembered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            memory_type TEXT NOT NULL CHECK (memory_type IN ('ephemeral', 'core'))
          );
        SQL

        db.execute <<~SQL
          CREATE INDEX IF NOT EXISTS idx_memories_type ON memories(memory_type);
        SQL

        db.execute <<~SQL
          CREATE INDEX IF NOT EXISTS idx_memories_remembered_at ON memories(remembered_at);
        SQL
      end
    end
  end
end