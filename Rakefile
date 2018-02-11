require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :build do

  desc 'Build README.md file from README.template.md'
  task :readme do
    require_relative 'lib/markdown_helper'
    markdown_helper = MarkdownHelper.new
    markdown_helper.include('README.template.md', 'README.md')
  end

end

task :default => :test
