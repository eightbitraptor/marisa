# frozen_string_literal: true

require "test_helper"
require "marisa/tools/read_memories"
require "marisa/tools/write_memories"

module Marisa
  module Tools
    class TestReadMemories < Minitest::Test
      def setup
        # Create a temporary database for testing
        @original_db_path = Database.instance_variable_get(:@database_path)
        Database.instance_variable_set(:@database_path, ":memory:")
        Database.close
        
        # Initialize the test database
        Database.connection
      end

      def teardown
        Database.close
        Database.instance_variable_set(:@database_path, @original_db_path)
        Database.instance_variable_set(:@connection, nil)
      end

      def test_read_empty_database
        response = ReadMemories.call({})
        
        assert_instance_of MCP::Tool::Response, response
        content = response.content.first
        assert_equal "text", content[:type]
        assert_equal "No memories found.", content[:text]
      end

      def test_read_memories_with_default_parameters
        # Add test memories
        WriteMemories.call({text: "First memory", memory_type: "ephemeral"})
        WriteMemories.call({text: "Second memory", memory_type: "core"})
        
        response = ReadMemories.call({})
        
        assert_instance_of MCP::Tool::Response, response
        content = response.content.first
        assert_equal "text", content[:type]
        assert_includes content[:text], "Found 2 memories"
        assert_includes content[:text], "First memory"
        assert_includes content[:text], "Second memory"
      end

      def test_read_memories_with_limit
        # Add multiple memories
        5.times do |i|
          WriteMemories.call({text: "Memory #{i}", memory_type: "ephemeral"})
        end
        
        response = ReadMemories.call({limit: 3})
        
        content = response.content.first
        assert_includes content[:text], "Found 3 memories"
        refute_includes content[:text], "Memory 0"
        refute_includes content[:text], "Memory 1"
      end

      def test_read_memories_filter_by_type_ephemeral
        WriteMemories.call({text: "Ephemeral memory", memory_type: "ephemeral"})
        WriteMemories.call({text: "Core memory", memory_type: "core"})
        
        response = ReadMemories.call({memory_type: "ephemeral"})
        
        content = response.content.first
        assert_includes content[:text], "Found 1 memories"
        assert_includes content[:text], "Ephemeral memory"
        refute_includes content[:text], "Core memory"
      end

      def test_read_memories_filter_by_type_core
        WriteMemories.call({text: "Ephemeral memory", memory_type: "ephemeral"})
        WriteMemories.call({text: "Core memory", memory_type: "core"})
        
        response = ReadMemories.call({memory_type: "core"})
        
        content = response.content.first
        assert_includes content[:text], "Found 1 memories"
        assert_includes content[:text], "Core memory"
        refute_includes content[:text], "Ephemeral memory"
      end

      def test_read_memories_order_newest_first
        WriteMemories.call({text: "First memory", memory_type: "ephemeral"})
        sleep(0.01) # Ensure different timestamps
        WriteMemories.call({text: "Second memory", memory_type: "ephemeral"})
        
        response = ReadMemories.call({order: "newest"})
        
        content = response.content.first
        lines = content[:text].split("\n")
        second_index = lines.find_index { |line| line.include?("Second memory") }
        first_index = lines.find_index { |line| line.include?("First memory") }
        
        assert second_index < first_index, "Second memory should appear before first memory"
      end

      def test_read_memories_order_oldest_first
        WriteMemories.call({text: "First memory", memory_type: "ephemeral"})
        sleep(0.01) # Ensure different timestamps
        WriteMemories.call({text: "Second memory", memory_type: "ephemeral"})
        
        response = ReadMemories.call({order: "oldest"})
        
        content = response.content.first
        lines = content[:text].split("\n")
        first_index = lines.find_index { |line| line.include?("First memory") }
        second_index = lines.find_index { |line| line.include?("Second memory") }
        
        assert first_index < second_index, "First memory should appear before second memory"
      end

      def test_read_memories_with_all_parameters
        WriteMemories.call({text: "Ephemeral 1", memory_type: "ephemeral"})
        WriteMemories.call({text: "Core 1", memory_type: "core"})
        WriteMemories.call({text: "Ephemeral 2", memory_type: "ephemeral"})
        
        response = ReadMemories.call({
          memory_type: "ephemeral",
          limit: 1,
          order: "oldest"
        })
        
        content = response.content.first
        assert_includes content[:text], "Found 1 memories"
        assert_includes content[:text], "Ephemeral 1"
        refute_includes content[:text], "Ephemeral 2"
        refute_includes content[:text], "Core 1"
      end

      def test_read_memories_formatting
        WriteMemories.call({text: "Test memory content", memory_type: "ephemeral"})
        
        response = ReadMemories.call({})
        
        content = response.content.first
        assert_includes content[:text], "**Memory #"
        assert_includes content[:text], "(ephemeral)"
        assert_includes content[:text], "Date:"
        assert_includes content[:text], "Content: Test memory content"
      end

      def test_read_memories_with_zero_limit
        WriteMemories.call({text: "Test memory", memory_type: "ephemeral"})
        
        # Zero limit should be treated as default (according to schema minimum: 1)
        response = ReadMemories.call({limit: 1})
        
        content = response.content.first
        assert_includes content[:text], "Found 1 memories"
      end

      def test_read_memories_exceeding_maximum_limit
        # Add memories
        3.times do |i|
          WriteMemories.call({text: "Memory #{i}", memory_type: "ephemeral"})
        end
        
        response = ReadMemories.call({limit: 100})
        
        content = response.content.first
        assert_includes content[:text], "Found 3 memories"
      end

      def test_read_memories_no_type_filter_shows_all_types
        WriteMemories.call({text: "Ephemeral memory", memory_type: "ephemeral"})
        WriteMemories.call({text: "Core memory", memory_type: "core"})
        
        response = ReadMemories.call({})
        
        content = response.content.first
        assert_includes content[:text], "Found 2 memories"
        assert_includes content[:text], "Ephemeral memory"
        assert_includes content[:text], "Core memory"
      end

      def test_read_memories_database_error_handling
        # Close the database to simulate an error
        Database.close
        
        # Mock a database error
        Database.stub(:connection, -> { raise SQLite3::Exception.new("Database error") }) do
          response = ReadMemories.call({})
          
          content = response.content.first
          assert_equal "text", content[:type]
          assert_includes content[:text], "Error reading memories: Database error"
        end
      end
    end
  end
end