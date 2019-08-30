define i64 @prim_any_to_string(i64 %any) {
	; TODO
	ret i64 %any
}

define i64 @prim_display(i64 %any) {
	; make a string from it
	%string = call i64 @prim_any_to_string(i64 %any)
	; remove the tag
        %string_tag = load i64, i64* @prim_string_tag
        %string_addr = xor i64 %string, %string_tag
	; make a pointer from it
	%string_ptr = inttoptr i64 %string_addr to i64*
	%string_i8_ptr = bitcast i64* %string_ptr to i8*
	; call puts
	call i64 @puts(i8* %string_i8_ptr)
	; just return true, no error treatment at the moment
	%res_true = load i64, i64* @prim_bool_true
	ret i64 %res_true
}
