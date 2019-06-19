<!-- >>>>>> BEGIN GENERATED FILE (include): SOURCE markdown/use_cases/include_files/reuse_text/use_case_template.md -->
<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/included.md -->
<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/includer.md -->
<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/includee.md -->
### Reuse Text

Use file inclusion to stay DRY (Don't Repeat Yourself).

Maintain reusable text in a separate file, then include it wherever it's needed.

#### File To Be Included

Text in includee file.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/includee.md -->

#### Includer File

<!-- >>>>>> BEGIN INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/includee.md -->
Text in includer file.

Text in includee file.
<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/includee.md -->

<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/includer.md -->

The treatment token ```:markdown``` specifies that the included text is to be treated as more markdown.


#### File with Inclusion

Here's the output file, after inclusion.

Text in includer file.

Text in includee file.

<!-- <<<<<< END INCLUDED FILE (markdown): SOURCE markdown/use_cases/include_files/reuse_text/included.md -->
<!-- <<<<<< END GENERATED FILE (include): SOURCE markdown/use_cases/include_files/reuse_text/use_case_template.md -->
