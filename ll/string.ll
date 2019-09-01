; structure of string:
; i8 %char_0 | i8 %char_1 | ... | i8 0 | ... | i8 0
; (until 8 bytes are filled because of alignment)

@prim_fixnum_format = private constant [3 x i8] c"%d\00", align 8

@prim_bool_true_string = private constant [3 x i8] c"#t\00", align 8
@prim_bool_false_string = private constant [3 x i8] c"#f\00", align 8

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

; TODO: char, empty list, pair, vector, symbol, closure
define i64 @prim_any_to_string(i64 %any) {
test_fixnum:
	%fixnum_tag = load i64, i64* @prim_fixnum_tag
	%fixnum_mask = load i64, i64* @prim_fixnum_mask
	%any_fixnum_tag = and i64 %any, %fixnum_mask
	%fixnum_test = icmp eq i64 %any_fixnum_tag, %fixnum_tag
	br i1 %fixnum_test, label %fixnum_to_string, label %test_bool
fixnum_to_string:
	%fixnum_string = call i64 @prim_fixnum_to_string(i64 %any)
	ret i64 %fixnum_string
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
	br i1 %string_test, label %string_to_string, label %error
string_to_string:
	ret i64 %any
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
