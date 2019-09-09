define i64 @prim_string_to_symbol(i64 %string) {
	; remove the tag
        %string_tag = load i64, i64* @prim_string_tag
        %string_addr = xor i64 %string, %string_tag
	; make a pointer from it
	%string_ptr = inttoptr i64 %string_addr to i64*
	%string_i8_ptr = bitcast i64* %string_ptr to i8*
	; create the symbol
	%tagged_symbol_addr = call i64 @___reserved_symbols_create(i8* %string_i8_ptr)
	ret i64 %tagged_symbol_addr
}

define i64 @prim_is_symbol(i64 %value) {
        %res = call i64 @___reserved_has_tag(i64* @prim_symbol_tag, i64* @prim_heap_mask, i64 %value)
        ret i64 %res
}

define i64 @prim_symbol_equal(i64 %x, i64 %y) {
	; check tag equality first
        %heap_mask = load i64, i64* @prim_heap_mask
        %x_tag = and i64 %x, %heap_mask
        %y_tag = and i64 %y, %heap_mask
        %tag_test = icmp eq i64 %x_tag, %y_tag
        br i1 %tag_test, label %check_symbol_equality, label %not_equal
check_symbol_equality:
	; we simply compare the symbols as they are, because
	; symbols of equal strings have equal addresses
        %test = icmp eq i64 %x, %y
        br i1 %test, label %equal, label %not_equal
equal:
        %res_equal = load i64, i64* @prim_bool_true
        ret i64 %res_equal
not_equal:
        %res_not_equal = load i64, i64* @prim_bool_false
        ret i64 %res_not_equal
}
