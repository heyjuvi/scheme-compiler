; TODO: anything beside false is true!
define i64 @prim_bool_and(i64 %x, i64 %y) {
	%res = and i64 %x, %y
	ret i64 %res
}

define i64 @prim_bool_or(i64 %x, i64 %y) {
	%res = or i64 %x, %y
	ret i64 %res
}

define i64 @prim_bool_not(i64 %x) {
	%bool_false = load i64, i64* @prim_bool_false
	%test = icmp eq i64 %x, %bool_false
	br i1 %test, label %false, label %true
true:
	%res_false = load i64, i64* @prim_bool_false
	ret i64 %res_false
false:
	%res_true = load i64, i64* @prim_bool_true
	ret i64 %res_true
}

define i64 @prim_is_bool(i64 %value) {
        %res = call i64 @___reserved_has_tag(i64* @prim_bool_tag, i64* @prim_bool_mask, i64 %value)
        ret i64 %res
}

define i64 @prim_bool_equal(i64 %x, i64 %y) {
	%test = icmp eq i64 %x, %y
	br i1 %test, label %equal, label %not_equal
equal:
	%res_equal = load i64, i64* @prim_bool_true
	ret i64 %res_equal
not_equal:
	%res_not_equal = load i64, i64* @prim_bool_false
	ret i64 %res_not_equal
}
