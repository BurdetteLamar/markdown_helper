require_relative '../../use_case'

class GemifyImages < UseCase

  def self.build

    use_case_dir_path = File.absolute_path(File.dirname(__FILE__))

    use_case = self.new(use_case_dir_path)

    reusable_text_file_name = 'reusable_text.md'
    includer_file_name = 'includer.md'
    included_file_name = 'included.md'

    resolve_command = use_case.construct_resolve_command(includer_file_name, included_file_name, pristine = true)
    build_command = use_case.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

    use_case.commands_to_execute.push(
        resolve_command,
        build_command,
    )

#
#     relative_image_file_name = 'relative_image.md'
# absolute_image_file_name = 'resolved_image.md'
# template_file_name = 'template.md'
# use_case_file_name = 'gemify_images.md'
#
# resolve_command = "markdown_helper resolve --pristine #{relative_image_file_name} #{absolute_image_file_name}"
#
# File.write(
#     relative_image_file_name,
#     <<EOT
# ![html_image](../../../images/html.png)
# EOT
# )
#
# # Example resolution.
# # system(resolve_command)
#
# File.write(
#     template_file_name,
#     <<EOT
# ### Gemify Images
#
# Use the markdown helper to resolve image paths for a Ruby gem.
#
# #### The Problem
#
# When you release your GitHub project to  gem at RubyGems.org, the documentation is rebuilt into files on RubyDoc.info.  When YARD performs this rebuilding, it does some directory restructuring.
#
# If a markdown file contains an image description that has a relative file path, that path will not be valid in the documentation on RubyDoc.info, and the image will not display in the documentation.
#
# #### The Solution
#
# To avoid that error, use the markdown helper to resolve the relative path to an absolute path.
#
# This new absolute path points to a file that's automatically maintained in the GitHub project.  For that reason,
# EOT
# )
#
# # Build use case.
# # build_command = "markdown_helper include --pristine #{template_file_name} #{use_case_file_name}"
# # system(build_command)

  end

end
