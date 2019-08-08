define i64 @prim_fixnum_add1(i64 %x) {
	%res = add i64 %x, 4
	ret i64 %res
}

define i64 @prim_fixnum_sub1(i64 %x) {
	%res = sub i64 %x, 4
	ret i64 %res
}

define i64 @prim_fixnum_add(i64 %x, i64 %y) {
	%res = add i64 %x, %y
	ret i64 %res
}

define i64 @prim_fixnum_sub(i64 %x, i64 %y) {
	%res = sub i64 %x, %y
	ret i64 %res
}

define i64 @prim_fixnum_mul(i64 %x, i64 %y) {
	%tmp = lshr i64 %y, 2
	%res = mul i64 %x, %tmp
	ret i64 %res
}

define i64 @prim_fixnum_div(i64 %x, i64 %y) {
	%tmp = sdiv i64 %x, %y
	%res = shl i64 %tmp, 2
	ret i64 %res
}

define i64 @prim_fixnum_equal(i64 %x, i64 %y) {
	%test = icmp eq i64 %x, %y
	br i1 %test, label %equal, label %not_equal
equal:
	%res_equal = load i64, i64* @prim_bool_true
	ret i64 %res_equal
not_equal:
	%res_not_equal = load i64, i64* @prim_bool_false
	ret i64 %res_not_equal
}

define i64 @prim_fixnum_less(i64 %x, i64 %y) {
	%test = icmp slt i64 %x, %y
	br i1 %test, label %less, label %not_less
less:
	%res_less = load i64, i64* @prim_bool_true
	ret i64 %res_less
not_less:
	%res_not_less = load i64, i64* @prim_bool_false
	ret i64 %res_not_less
}

define i64 @prim_fixnum_greater(i64 %x, i64 %y) {
	%test = icmp sgt i64 %x, %y
	br i1 %test, label %greater, label %not_greater
greater:
	%res_greater = load i64, i64* @prim_bool_true
	ret i64 %res_greater
not_greater:
	%res_not_greater = load i64, i64* @prim_bool_false
	ret i64 %res_not_greater
}
