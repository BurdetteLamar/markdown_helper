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
      # Do the resolve before the include, so that the included text is not also resolved.
      # This protects example code from being also resolved, thus damaging the example code.
      # Temp file must be in the same directory as its source (it becomes the source).
      temp_file_path = 'temp_resolved.md'
      markdown_helper.resolve('README.template.md', temp_file_path)
      readme_file_path = '../../README.md'
      markdown_helper.include(temp_file_path, readme_file_path)
      File.delete(temp_file_path)
    end
  end

  desc 'Build usage for executables'
  task :usages do
    %w/
        include
        resolve
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
