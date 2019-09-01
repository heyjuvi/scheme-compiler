define i64 @prim_bool_and(i64 %x, i64 %y) {
	%res = and i64 %x, %y
	ret i64 %res
}

define i64 @prim_bool_or(i64 %x, i64 %y) {
	%res = or i64 %x, %y
	ret i64 %res
}
