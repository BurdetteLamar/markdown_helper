class MarkdownHelper

  attr_accessor :pristine

  class MarkdownHelperError < RuntimeError; end
  class OptionError < MarkdownHelperError; end
  class MultiplePageTocError < MarkdownHelperError; end
  class UnreadableTemplateError < MarkdownHelperError; end
  class UnwritableMarkdownError < MarkdownHelperError; end
  class InvalidTocTitleError < MarkdownHelperError; end
  class CircularIncludeError < MarkdownHelperError; end
  class UnreadableIncludeeError < MarkdownHelperError; end

  def MarkdownHelper.git_clone_dir_path
    git_dir = `git rev-parse --show-toplevel`.chomp
    unless $?.success?
      message = <<EOT

Markdown helper must run inside a .git project.
That is, the working directory one of its parents must be a .git directory.
EOT
      raise RuntimeError.new(message)
    end
    git_dir
  end

  def initialize(options = {})
    # Confirm that we're in a git project.
    # This is necessary so that we can prune file paths in the tests,
    # which otherwise would fail because of differing installation directories.
    # It also allows pruned paths to be used in the inserted comments (when not pristine).
    MarkdownHelper.git_clone_dir_path
    default_options = {
        :pristine => false,
    }
    merged_options = default_options.merge(options)
    merged_options.each_pair do |method, value|
      unless self.respond_to?(method)
        raise OptionError.new("Unknown option: #{method}")
      end
      setter_method = "#{method}="
      send(setter_method, value)
      merged_options.delete(method)
    end
  end

  def generate_file(method, template_file_path, markdown_file_path)
    template_path_in_project = MarkdownHelper.path_in_project(template_file_path)
    output_lines = []
    yield output_lines
    output_lines = output_lines.collect { |line| line.chomp }
    unless pristine
      output_lines.unshift(MarkdownHelper.comment(" >>>>>> BEGIN GENERATED FILE (#{method}): SOURCE #{template_path_in_project} "))
      output_lines.push(MarkdownHelper.comment(" <<<<<< END GENERATED FILE (#{method}): SOURCE #{template_path_in_project} "))
    end
    output_lines.push('')
    output = output_lines.join("\n")
    File.write(markdown_file_path, output)
  end

  def run_irb(template_file_path, markdown_file_path)
    irb_runner = MarkdownIrbRunner.new(:pristine => pristine)
    irb_runner.run_irb(template_file_path, markdown_file_path)
  end

  def include(template_file_path, markdown_file_path)
    includer = MarkdownIncluder.new(:pristine => pristine)
    includer.include(template_file_path, markdown_file_path)
  end

  def self.comment(text)
    "<!--#{text}-->"
  end

  def self.path_in_project(file_path)
    abs_path = File.absolute_path(file_path)
    abs_path.sub(MarkdownHelper.git_clone_dir_path + '/', '')
  end

end
