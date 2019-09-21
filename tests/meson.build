std_source_files = files([
  '../ll/common.ll',
  '../ll/fixnum.ll',
  '../ll/char.ll',
  '../ll/bool.ll',
  '../ll/pair.ll',
  '../ll/vector.ll',
  '../ll/closure.ll',
  '../ll/string.ll',
  '../ll/symbol.ll',
  '../ll/generic.ll',
  '../ll/port.ll'
])

tests = [
  [ 'Testing the fixnum primitive', 'fixnum.scm' ],
  [ 'Testing the char primitive', 'char.scm' ],
  [ 'Testing the bool primitive', 'bool.scm' ],
  [ 'Testing the pair primitive', 'pair.scm' ],
  [ 'Testing the vector primitive', 'vector.scm' ],
  [ 'Testing the closure primitive', 'closure.scm' ],
  [ 'Testing the string primitive', 'string.scm' ],
  [ 'Testing the symbol primitive', 'symbol.scm' ],
  [ 'Testing the if expression behaviour', 'if.scm' ],
  [ 'Testing the begin expression behaviour', 'begin.scm' ],
  [ 'Testing the let expression behaviour', 'let.scm' ],
  [ 'Testing the cond expression behaviour', 'cond.scm' ],
  [ 'Testing the set! expression behaviour', 'set.scm' ],
  [ 'Testing the input/output facilities', 'io.scm' ],
]

foreach test_data : tests
  test_description = test_data[0]
  test_source_filename = test_data[1]

  combined_test_source = custom_target(test_source_filename + '_combined_test-target',
    output : test_source_filename + '.combined.scm',
    input : [ 'test-lib.scm', test_source_filename ],
    command : [ source_combiner, '@INPUT@' ],
    capture : true)
  test_ll_source = custom_target(test_source_filename + '_ll-target',
    output : test_source_filename + '.ll',
    input : combined_test_source,
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
    sources : [ combined_test_ll_object ],
    c_args : [ '-m64', '-g' ],
    link_args : [ '-no-pie' ])
  test(test_description, test_executable)
endforeach

self_source_files = files([
  '../compat-slang.scm',
  '../dbg_misc.scm',
  '../parser.scm',
  '../forms.scm',
  '../ll.scm',
  '../preprocess.scm',
  '../data-types.scm',
  '../closure-conversion.scm',
  '../codegen.scm'
])

self_combined_source_file = 'self_combined.scm'
self_combined_source = custom_target('self_combined',
  output : self_combined_source_file,
  input : self_source_files,
  command : [ source_combiner, '@INPUT@' ],
  capture : true)
self_ll_source = custom_target('slang_ll',
  output : 'self_combined.ll',
  input : self_combined_source,
  command : [ slang_compiler, '@INPUT@' ],
  capture : true)
combined_self_ll_source = custom_target('combined_slang_ll-target',
  output : 'self_combined.with_std.ll',
  input : std_source_files + [ self_ll_source ],
  command : [ source_combiner, '@INPUT@' ],
  capture : true)
combined_self_ll_object = custom_target('combined_slang_object-target',
  output : 'slang.o',
  input : combined_self_ll_source,
  command : [ llvm_ir_compiler, '@INPUT@', '--filetype=obj', '-O3', '-o', '@OUTPUT@' ])
self_executable = executable('slang',
  sources : [ combined_self_ll_object ],
  c_args : [ '-m64', '-O3', '-g' ],
  link_args : [ '-no-pie' ])

#foreach test_data : tests
#  test_description = test_data[0]
#  test_source_filename = test_data[1]
#
#  test_ll_source = custom_target(test_source_filename + '_ll-target-self',
#    output : test_source_filename + '.self.ll',
#    input : test_source_filename,
#    command : [ self_executable, '@INPUT@' ],
#    capture : true)
#  combined_test_ll_source = custom_target(test_source_filename + '_combined_test_ll-target-self',
#    output : test_source_filename + '.self.combined.ll',
#    input : std_source_files + [ test_ll_source ],
#    command : [ source_combiner, '@INPUT@' ],
#    capture: true)
#  combined_test_ll_object = custom_target(test_source_filename + '_combined_test_object-target-self',
#    output : test_source_filename + '.self.o',
#    input : combined_test_ll_source,
#    command : [ llvm_ir_compiler, '@INPUT@', '--filetype=obj', '-o', '@OUTPUT@' ])
#  test_executable = executable(test_source_filename + '.self.elf',
#    sources : [ combined_test_ll_object ],
#    c_args : [ '-m64', '-g' ],
#    link_args : [ '-no-pie' ])
#  test(test_description, test_executable)
#endforeach

