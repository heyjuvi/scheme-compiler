define i64 @prim_is_char(i64 %value) {
        %res = call i64 @___reserved_has_tag(i64* @prim_char_tag, i64* @prim_char_mask, i64 %value)
        ret i64 %res
}

define i64 @prim_char_equal(i64 %x, i64 %y) {
	%res = call i64 @prim_fixnum_equal(i64 %x, i64 %y)
	ret i64 %res
}

