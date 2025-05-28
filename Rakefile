# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

namespace :test do
  Rake::TestTask.new(:unit) do |t|
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList["test/marisa/**/test_*.rb"]
  end

  Rake::TestTask.new(:system) do |t|
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList["test/system/test_*.rb"]
  end

  task :all => [:unit, :system]
end

task default: %i[test:all]
