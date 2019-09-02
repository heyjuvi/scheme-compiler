std_source_files = files([
  '../ll/common.ll',
  '../ll/fixnum.ll',
  '../ll/bool.ll',
  '../ll/pair.ll',
  '../ll/vector.ll',
  '../ll/closure.ll',
  '../ll/string.ll',
  '../ll/generic.ll'
])

tests = [
  [ 'Test of the vector primitive data type', 'vector.scm' ],
  [ 'Test of the closure primitive data type', 'closure.scm' ],
  [ 'Test of the string primitive data type', 'string.scm' ],
  [ 'Test of the begin expression behaviour', 'begin.scm' ],
  [ 'Test of the let expression behaviour', 'let.scm' ],
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
    output : test_source_filename + '.ll',
    input : test_source_filename,
    command : [ slang_compiler, '@INPUT@' ],
    capture : true)
  combined_test_ll_source = custom_target(test_source_filename + '_combined_test_ll-target',
    output : test_source_filename + '.combined.ll',
    input : std_source_files + [ test_ll_source ],
    command : [ source_combiner, '@INPUT@' ],
    capture : true)
  combined_test_ll_object = custom_target(test_source_filename + '_combined_test_object-target',
    output : test_source_filename + '.o',
    input : combined_test_ll_source,
    command : [ llvm_ir_compiler, '@INPUT@', '--filetype=obj', '-o', '@OUTPUT@' ])
  test_executable = executable(test_source_filename + '.elf',
    sources : [ combined_test_ll_object, driver_object ],
    c_args : [ '-m64', '-g' ],
    link_args : [ '-no-pie' ])
  test(test_description, test_executable)
endforeach
