require 'bundler/gem_tasks'
require 'rake/testtask'

require_relative 'lib/markdown_helper'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :build do

  desc 'Build README.md file from README.template.md'
  task :readme do
    Rake::Task['build:usages'].invoke
    Dir.chdir('markdown/readme') do
      markdown_helper = MarkdownHelper.new
      template_file_path = 'highlight_ruby_template.md'
      markdown_file_path = 'highlighted_ruby.md'
      markdown_helper.include(template_file_path, markdown_file_path)
      markdown_helper.include('README.template.md', '../../README.md')
    end
  end

  desc 'Build usage for executables'
  task :usages do
    %w/
        include
    /.each do |executable_name|
      usage_text = `ruby bin/_#{executable_name} --help`
      usage_file_path = "bin/usage/#{executable_name}.txt"
      File.open(usage_file_path, 'w') do |file|
        file.puts(usage_text)
      end
    end
  end

end

task :default => :test
