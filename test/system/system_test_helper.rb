# frozen_string_literal: true

require "test_helper"
require "open3"
require "json"

module SystemTestHelper
  def setup
    start_process
    super
  end

  def teardown
    stop_process
    super
  end

  private

  def start_process
    executable = File.expand_path("../../bin/marisa", __dir__)
    @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(executable)
  end

  def stop_process
    @stdin&.close
    @stdout&.close
    @stderr&.close
    @wait_thr&.value # Wait for the process to finish
  end

  def send_command(command)
    @stdin.puts(command.to_json)
    @stdin.flush

    response = @stdout.gets
    JSON.parse(response)
  rescue JSON::ParserError
    # If we got a non-JSON response, return it as-is
    { "error" => response }
  end
end 
