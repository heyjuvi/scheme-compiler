; structure of string:
; i8 %char_0 | i8 %char_1 | ... | i8 0 | ... | i8 0
; (until 8 bytes are filled because of alignment)

@prim_fixnum_format = private constant [3 x i8] c"%d\00", align 8

@prim_bool_true_string = private constant [3 x i8] c"#t\00", align 8
@prim_bool_false_string = private constant [3 x i8] c"#f\00", align 8

define i64 @prim_string_length(i64 %string) {
	; remove the tag
        %string_tag = load i64, i64* @prim_string_tag
        %string_addr = xor i64 %string, %string_tag
	; make a pointer from it
	%string_ptr = inttoptr i64 %string_addr to i64*
	%string_i8_ptr = bitcast i64* %string_ptr to i8*
	; call strlen
	%length = call i64 @strlen(i8* %string_i8_ptr);
	; set the fixnum tag
        %fixnum_tag = load i64, i64* @prim_fixnum_tag
        %fixnum_shift = load i64, i64* @prim_fixnum_shift
	%shifted_length = shl i64 %length, %fixnum_shift
        %tagged_length = or i64 %shifted_length, %fixnum_tag
	; return the length
	ret i64 %tagged_length
}

define i64 @prim_is_string(i64 %value) {
        %res = call i64 @___reserved_has_tag(i64* @prim_string_tag, i64* @prim_heap_mask, i64 %value)
        ret i64 %res
}

define i64 @prim_string_equal(i64 %string1, i64 %string2) {
	; check tag equality first
        %heap_mask = load i64, i64* @prim_heap_mask
        %string1_tag = and i64 %string1, %heap_mask
        %string2_tag = and i64 %string2, %heap_mask
        %tag_test = icmp eq i64 %string1_tag, %string2_tag
        br i1 %tag_test, label %check_string_equality, label %not_equal
check_string_equality:
	; remove the tags
        %string_tag = load i64, i64* @prim_string_tag
        %string1_addr = xor i64 %string1, %string_tag
        %string2_addr = xor i64 %string2, %string_tag
	; make pointers from it
	%string1_ptr = inttoptr i64 %string1_addr to i64*
	%string2_ptr = inttoptr i64 %string2_addr to i64*
	%string1_i8_ptr = bitcast i64* %string1_ptr to i8*
	%string2_i8_ptr = bitcast i64* %string2_ptr to i8*
	; call strcmp
	%strcmp_equal = call i64 @strcmp(i8* %string1_i8_ptr, i8* %string2_i8_ptr)
	%test_equal = icmp eq i64 %strcmp_equal, 0
	br i1 %test_equal, label %equal, label %not_equal
equal:
	%res_equal = load i64, i64* @prim_bool_true
	ret i64 %res_equal
not_equal:
	%res_not_equal = load i64, i64* @prim_bool_false
	ret i64 %res_not_equal
}

define i64 @prim_string_ref(i64 %string, i64 %index) {
	; remove the tag from the string
        %string_tag = load i64, i64* @prim_string_tag
        %string_addr = xor i64 %string, %string_tag
	; make a pointer from it
	%string_ptr = inttoptr i64 %string_addr to i64*
	%string_i8_ptr = bitcast i64* %string_ptr to i8*
	; unshift the index
        %fixnum_shift = load i64, i64* @prim_fixnum_shift
        %unshifted_index = lshr i64 %index, %fixnum_shift
	; get the element
	%char_ptr = getelementptr i8, i8* %string_i8_ptr, i64 %unshifted_index
	%char = load i8, i8* %char_ptr
	%ext_char = zext i8 %char to i64
	%char_shift = load i64, i64* @prim_char_shift
	%shifted_char = shl i64 %ext_char, %char_shift
	; tag the char and return it
	%char_tag = load i64, i64* @prim_char_tag
	%tagged_char = or i64 %shifted_char, %char_tag
	ret i64 %tagged_char
}

define i64 @prim_string_append(i64 %string1, i64 %string2) {
	; remove the tags
        %string_tag = load i64, i64* @prim_string_tag
        %string1_addr = xor i64 %string1, %string_tag
        %string2_addr = xor i64 %string2, %string_tag
	; make pointers from it
	%string1_ptr = inttoptr i64 %string1_addr to i64*
	%string2_ptr = inttoptr i64 %string2_addr to i64*
	%string1_i8_ptr = bitcast i64* %string1_ptr to i8*
	%string2_i8_ptr = bitcast i64* %string2_ptr to i8*
	; make a new string
	%new_string_addr = call i64 @___reserved_heap_store_i8_array(i8* %string1_i8_ptr)
	call i64 @___reserved_heap_store_i8_array(i8* %string2_i8_ptr)
	call i64 @___reserved_heap_store_i8(i8 0)
	call i64 @___reserved_heap_align()
	; set the string tag
        %tagged_new_string_addr = or i64 %new_string_addr, %string_tag
	; return the freshly created string
	ret i64 %tagged_new_string_addr
}

define i64 @prim_fixnum_to_string(i64 %x) {
	; setup enough heap storage for the string
	%string_addr = call i64 @___reserved_heap_store_i64(i64 0)
	call i64 @___reserved_heap_store_i64(i64 0)
	call i64 @___reserved_heap_store_i64(i64 0)
	; make a pointer from it
	%string_ptr = inttoptr i64 %string_addr to i64*
	%string_i8_ptr = bitcast i64* %string_ptr to i8*
	; remove the tag
	%fixnum_shift = load i64, i64* @prim_fixnum_shift
        %num = lshr i64 %x, %fixnum_shift
	; get the string format for snprintf
	%fixnum_format_bounds = getelementptr inbounds [3 x i8], [3 x i8]* @prim_fixnum_format, i64 0
	%fixnum_format = bitcast [3 x i8]* %fixnum_format_bounds to i8*
	; call snprintf
	call i64 (i8*, i64, i8*, ...) @snprintf(i8* %string_i8_ptr, i64 24, i8* %fixnum_format, i64 %num)
	; set the string tag
        %string_tag = load i64, i64* @prim_string_tag
        %tagged_string_addr = or i64 %string_addr, %string_tag
	; return the freshly created string
	ret i64 %tagged_string_addr
}

define i64 @prim_bool_to_string(i64 %bool) {
	%bool_true = load i64, i64* @prim_bool_true
	%string_tag = load i64, i64* @prim_string_tag
	%true_test = icmp eq i64 %bool, %bool_true
	br i1 %true_test, label %get_true_string, label %get_false_string
get_true_string:
	%true_string_bounds = getelementptr inbounds [3 x i8], [3 x i8]* @prim_bool_true_string, i64 0
	%true_string_ptr = bitcast [3 x i8]* %true_string_bounds to i64*
	%true_string_addr = ptrtoint i64* %true_string_ptr to i64
	%tagged_true_string_addr = or i64 %true_string_addr, %string_tag
	ret i64 %tagged_true_string_addr
get_false_string:
	%false_string_bounds = getelementptr inbounds [3 x i8], [3 x i8]* @prim_bool_false_string, i64 0
	%false_string_ptr = bitcast [3 x i8]* %false_string_bounds to i64*
	%false_string_addr = ptrtoint i64* %false_string_ptr to i64
	%tagged_false_string_addr = or i64 %false_string_addr, %string_tag
	ret i64 %tagged_false_string_addr
}

define i64 @prim_char_to_string(i64 %char) {
	; get char shift
	%char_shift = load i64, i64* @prim_char_shift
	%string_tag = load i64, i64* @prim_string_tag
	; put the array onto the heap
	%unshifted_char = lshr i64 %char, %char_shift
	%tmp_char1 = lshr i64 %unshifted_char, 16
	%char1 = trunc i64 %tmp_char1 to i8
	%tmp_char2 = lshr i64 %unshifted_char, 8
	%char2 = trunc i64 %tmp_char2 to i8
	%char3 = trunc i64 %unshifted_char to i8
	; TODO: not sure, if this works out correctly
	%string = call i64 @___reserved_heap_store_i8(i8 %char3)
	call i64 @___reserved_heap_store_i8(i8 %char2)
	call i64 @___reserved_heap_store_i8(i8 %char1)
	call i64 @___reserved_heap_store_i8(i8 0)
	call i64 @___reserved_heap_align()
	; tag the string and return it
	%tagged_string = or i64 %string, %string_tag
	ret i64 %tagged_string
}

define i64 @prim_symbol_to_string(i64 %symbol) {
	; get the symbol and the string tag
	%symbol_tag = load i64, i64* @prim_symbol_tag
	%string_tag = load i64, i64* @prim_string_tag
	; remove the tag
	%symbol_addr = xor i64 %symbol, %symbol_tag
	; add the string tag and return the tagged string
	%tagged_string = or i64 %symbol_addr, %string_tag
	ret i64 %tagged_string
}

; TODO: empty list, pair, vector, symbol, closure
define i64 @prim_any_to_string(i64 %any) {
test_fixnum:
	%fixnum_tag = load i64, i64* @prim_fixnum_tag
	%fixnum_mask = load i64, i64* @prim_fixnum_mask
	%any_fixnum_tag = and i64 %any, %fixnum_mask
	%fixnum_test = icmp eq i64 %any_fixnum_tag, %fixnum_tag
	br i1 %fixnum_test, label %fixnum_to_string, label %test_char
fixnum_to_string:
	%fixnum_string = call i64 @prim_fixnum_to_string(i64 %any)
	ret i64 %fixnum_string
test_char:
	%char_tag = load i64, i64* @prim_char_tag
	%char_mask = load i64, i64* @prim_char_mask
	%any_char_tag = and i64 %any, %char_mask
	%char_test = icmp eq i64 %any_char_tag, %char_tag
	br i1 %char_test, label %char_to_string, label %test_bool
char_to_string:
	%char_string = call i64 @prim_char_to_string(i64 %any)
	ret i64 %char_string
test_bool:
	%bool_tag = load i64, i64* @prim_bool_tag
	%bool_mask = load i64, i64* @prim_bool_mask
	%any_bool_tag = and i64 %any, %bool_mask
	%bool_test = icmp eq i64 %any_bool_tag, %bool_tag
	br i1 %bool_test, label %bool_to_string, label %test_string
bool_to_string:
	%bool_string = call i64 @prim_bool_to_string(i64 %any)
	ret i64 %bool_string
test_string:
	%string_tag = load i64, i64* @prim_string_tag
	%string_mask = load i64, i64* @prim_heap_mask
	%any_string_tag = and i64 %any, %string_mask
	%string_test = icmp eq i64 %any_string_tag, %string_tag
	br i1 %string_test, label %string_to_string, label %test_symbol
string_to_string:
	ret i64 %any
test_symbol:
	%symbol_tag = load i64, i64* @prim_symbol_tag
	%symbol_mask = load i64, i64* @prim_heap_mask
	%any_symbol_tag = and i64 %any, %symbol_mask
	%symbol_test = icmp eq i64 %any_symbol_tag, %symbol_tag
	br i1 %symbol_test, label %symbol_to_string, label %error
symbol_to_string:
	%symbol_string = call i64 @prim_symbol_to_string(i64 %any)
	ret i64 %symbol_string
error:
	%res_false = load i64, i64* @prim_bool_false
	ret i64 %res_false
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

define i64 @prim_newline() {
	%newline = add i8 10, 0
	call i64 @putchar(i8 %newline)
	; just return true
	%res_true = load i64, i64* @prim_bool_true
	ret i64 %res_true	
}
