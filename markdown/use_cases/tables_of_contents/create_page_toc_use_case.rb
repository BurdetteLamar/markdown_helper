require_relative '../use_case'

class CreatePageTocUseCase < UseCase

  attr_accessor :use_case_dir_name

  TEMPLATE_FILE_NAME = 'use_case_template.md'
  TEXT_FILE_NAME = 'text.md'
  TOC_FILE_NAME = 'toc.md'
  INCLUDER_FILE_NAME = 'includer.md'
  PAGE_FILE_NAME = 'page.md'

  RUBY_FILE_NAME = 'include.rb'

  BUILD_COMMAND = UseCase.construct_include_command(TEMPLATE_FILE_NAME, USE_CASE_FILE_NAME, pristine = true)

  def initialize(use_case_dir_name)

    super

    commands_to_execute.push(RUBY_COMMAND) if File.exist?(RUBY_FILE_NAME)
    commands_to_execute.push(BUILD_COMMAND) if File.exist?(TEMPLATE_FILE_NAME)

    self.use_case_dir_name = use_case_dir_name

  end

  def use_case_dir_path
    File.join(File.absolute_path(File.dirname(__FILE__)), use_case_dir_name)
  end

  def write_includer_file
    File.write(
        INCLUDER_FILE_NAME,
        <<EOT
### Page Contents
        
@[:markdown](#{TOC_FILE_NAME})

@[:markdown](#{TEXT_FILE_NAME})
EOT
    )
  end

  def write_text_file
    File.write(
        TEXT_FILE_NAME,
        <<EOT
# Lorem Ipsum

Dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. 

## Curabitur Tortor

Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. 

### Quisque Volutpat

Cndimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. 

### Sed Lectus

Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. 

## Curabitur Sit
 
 Amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. 

### Vestibulum Nisi
 
 Lectus, commodo ac, facilisis ac, ultricies eu, pede. Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. Vivamus consectetuer risus et tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. 

### Sed Cursus

Ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. 

EOT
    )
  end

end