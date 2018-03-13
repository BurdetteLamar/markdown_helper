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
    markdown_helper.include('readme_files/highlight_ruby_template.md', 'readme_files/highlighted_ruby.md')
    # Do the resolve before the include, so that the included text is not also resolved.
    # Thie protects example code from being also resolved, thus damaging the example code.
    # Temp file must be in the same directory as its source (it becomes the source).
    temp_file_path = 'readme_files/temp_resolved.md'
    markdown_helper.resolve('readme_files/README.template.md', temp_file_path)
    markdown_helper.include(temp_file_path, 'README.md')
    File.delete(temp_file_path)
  end

end

task :default => :test
