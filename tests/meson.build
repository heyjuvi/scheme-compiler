std_source_files = files([
  '../ll/common.ll',
  '../ll/fixnum.ll',
  '../ll/bool.ll',
  '../ll/pair.ll',
  '../ll/vector.ll',
  '../ll/closure.ll',
  '../ll/string.ll',
  '../ll/symbol.ll',
  '../ll/generic.ll'
])

tests = [
  [ 'Testing the pair primitive', 'pair.scm' ],
  [ 'Testing the vector primitive', 'vector.scm' ],
  [ 'Testing the closure primitive', 'closure.scm' ],
  [ 'Testing the string primitive', 'string.scm' ],
  [ 'Testing the symbol primitive', 'symbol.scm' ],
  [ 'Testing the begin expression behaviour', 'begin.scm' ],
  [ 'Testing the let expression behaviour', 'let.scm' ],
  [ 'Testing the cond expression behaviour', 'cond.scm' ],
]

driver_source_file = 'driver.c'
driver_object_file = 'driver.c.o'
driver_object = custom_target('driver',
  output : driver_object_file,
  input : driver_source_file,
  command : [ c_compiler, '@INPUT@', '-m64', '-c', '-g', '-o', '@OUTPUT@' ])

foreach test_data : tests
  test_description = test_data[0]
  test_source_filename = test_data[1]

  test_ll_source = custom_target(test_source_filename + '_ll-target',
    output : '@BASENAME@.ll',
    input : test_source_filename,
    command : [ slang_compiler, '@INPUT@' ],
    capture : true)
  combined_test_ll_source = custom_target(test_source_filename + '_combined_test_ll-target',
    output : '@BASENAME@_combined.ll',
    input : test_ll_source,
    command : [ source_combiner, std_source_files, '@INPUT@' ],
    capture : true)
  test_executable = executable(test_source_filename + '.elf',
    sources : [ 'driver.c', combined_test_ll_source ],
    c_args : [ '-m64', '-g' ],
    link_args : [ '-no-pie' ])
  test(test_description, test_executable)
endforeach
