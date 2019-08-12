project('lispy', 'c')

source_combiner = find_program('cat')
scheme_compiler = find_program('chicken')

source_files = [ 'compat.scm', 'parser.scm', 'forms.scm', 'll.scm', 'preprocess.scm', 'data-types.scm', 'closure-conversion.scm', 'codegen.scm' ]
combined_source_file = 'combined.scm'
c_source_file = 'combined.c'

combined_source = custom_target('combined',
  output : combined_source_file,
  input : source_files,
  command : [ source_combiner, '@INPUT@' ],
  capture : true)

c_source = custom_target('c',
  output : c_source_file,
  input : combined_source,
  command : [ scheme_compiler, '@INPUT@', '-output-file', '@OUTPUT@' ])

chicken_lib = meson.get_compiler('c').find_library('chicken')

executable('sc',
  c_source,
  dependencies : chicken_lib,
  include_directories : '/usr/include/chicken/')

