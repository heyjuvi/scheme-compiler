; TODO: char, empty list, pair, vector, symbol, closure
define i64 @prim_generic_equal(i64 %a, i64 %b) {
test_fixnum:
	%fixnum_tag = load i64, i64* @prim_fixnum_tag
	%fixnum_mask = load i64, i64* @prim_fixnum_mask
	%a_fixnum_tag = and i64 %a, %fixnum_mask
	%fixnum_test = icmp eq i64 %a_fixnum_tag, %fixnum_tag
	br i1 %fixnum_test, label %check_fixnum_equality, label %test_bool
check_fixnum_equality:
	%fixnum_equal = call i64 @prim_fixnum_equal(i64 %a, i64 %b)
	ret i64 %fixnum_equal
test_bool:
	%bool_tag = load i64, i64* @prim_bool_tag
	%bool_mask = load i64, i64* @prim_bool_mask
	%a_bool_tag = and i64 %a, %bool_mask
	%bool_test = icmp eq i64 %a_bool_tag, %bool_tag
	br i1 %bool_test, label %check_bool_equality, label %test_string
check_bool_equality:
	%bool_equal = call i64 @prim_bool_equal(i64 %a, i64 %b)
	ret i64 %bool_equal
test_string:
	%string_tag = load i64, i64* @prim_string_tag
	%string_mask = load i64, i64* @prim_heap_mask
	%a_string_tag = and i64 %a, %string_mask
	%string_test = icmp eq i64 %a_string_tag, %string_tag
	br i1 %string_test, label %check_string_equality, label %error
check_string_equality:
	%string_equal = call i64 @prim_string_equal(i64 %a, i64 %b)
	ret i64 %string_equal
error:
	%res_false = load i64, i64* @prim_bool_false
	ret i64 %res_false
}
