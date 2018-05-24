require_relative '../include_use_case'

class DiagnoseCircularIncludes < IncludeUseCase

  def self.build

    use_case_name = File.basename(__FILE__, '.rb')
    use_case = self.new(use_case_name)

    use_case.write_ruby_file(pristine = true)

    [
        [0, 1],
        [1, 2],
        [2, 0],
    ].each do |indexes|
      includer_index, includee_index = *indexes
      includer_file_name = "includer_#{includer_index}.md"
      includee_file_name = "includer_#{includee_index}.md"
      if includer_index == 0
        include_description = "@[:markdown](#{includer_file_name})\n"
        File.write(INCLUDER_FILE_NAME, include_description)
      end
      include_description = "@[:markdown](#{includee_file_name})\n"
      File.write(includer_file_name, include_description)
    end

    File.write(
        TEMPLATE_FILE_NAME,
        <<EOT
### Diagnose Circular Includes

Use the backtrace of inclusions to diagnose and correct circular inclusions:  that is inclusions that directly or indirectly cause a file to include itself.

#### Files To Be Included

These files demonstrate nested inclusion, with circular inclusions.

@[markdown](includer_0.md)

@[markdown](includer_1.md)

@[markdown](includer_2.md)

#### Includer File

This file initiates the nested inclusions.

@[markdown](#{INCLUDER_FILE_NAME})

#### CLI

You can use the command-line interface to perform the inclusion.

##### Command

```sh
#{INCLUDE_COMMAND}
```

@[:markdown](../../pristine.md)

#### API

You can use the API to perform the inclusion.

##### Ruby Code

@[ruby](#{RUBY_FILE_NAME})

##### Command

```sh
#{RUBY_COMMAND}
```

#### Error and Backtrace

Here's the resulting backtrace of inclusions.

@[:code_block](diagnose_circular_includes.err)
EOT
    )

    use_case.build

  end

end
