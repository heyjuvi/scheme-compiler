;
; immediate types:
;
; fixnum: shift 2, tag 00b
; char: shift 8, tag 00001111b
; bool: shift 7, tag 0011111b
; empty list: no shift, 00101111b
;
; heap allocated types: shift 3
;
; pair: 001b
; vector: 010b
; string: 011b
; symbol: 101b
; closure: 110b
;

; basic libc functions
declare i8* @calloc(i64, i64)
declare void @free(i8*)

declare i64 @printf(i8*, ...)
declare i64 @putchar(i8)
declare i64 @strlen(i8*)
declare i64 @strcmp(i8*, i8*)
declare i64 @snprintf(i8*, i64, i8*, ...)
declare i64* @fopen(i8*, i8*)
declare i64 @fgetc(i64*)

declare void @exit(i8)

; basic heap management
@heap_base_ptr = global i8* zeroinitializer, align 8
@heap_index = global i64 0, align 8

; basic symbol management
@symbols_base_ptr = global i8* zeroinitializer, align 8
@symbols_index = global i64 0, align 8

; basic data type management
@prim_fixnum_tag = global i64 0
@prim_fixnum_shift = global i64 2
@prim_fixnum_mask = global i64 3

@prim_char_tag = global i64 15
@prim_char_shift = global i64 8
@prim_char_mask = global i64 255

@prim_bool_true = global i64 159
@prim_bool_false = global i64 31
@prim_bool_tag = global i64 31
@prim_bool_shift = global i64 7
@prim_bool_mask = global i64 127

@prim_pair_empty_list = global i64 47
@prim_pair_empty_list_mask = global i64 255

@prim_heap_shift = global i64 3
@prim_heap_mask = global i64 7

@prim_pair_tag = global i64 1
@prim_vector_tag = global i64 2
@prim_string_tag = global i64 3
@prim_symbol_tag = global i64 5
@prim_closure_tag = global i64 6

; process context
@argc = global i64 0
@argv = global i8** zeroinitializer

define i64 @___reserved_main() {
	; allocate the heap and store its pointer
	%heap_ptr = call i8* @calloc(i64 1601910490, i64 8)
	store i8* %heap_ptr, i8** @heap_base_ptr, align 8
	; allocate the symbols and store its pointer
	%symbols_ptr = call i8* @calloc(i64 1000000, i64 8)
	store i8* %symbols_ptr, i8** @symbols_base_ptr, align 8
	; call the main program
	%res = call i64 @scheme_main()
	; free the heap
	call void @free(i8* %heap_ptr)
	; return the result from the main program
	ret i64 %res
}

define i64 @main(i64 %argc, i8** %argv) {
	; store the process context
	store i64 %argc, i64* @argc
	store i8** %argv, i8*** @argv
	; call the actual main
	%res = call i64 @___reserved_main()
	; TODO: for now, expect a bool as last expression
	%bool_true = load i64, i64* @prim_bool_true
	%test_res = icmp eq i64 %res, %bool_true
	br i1 %test_res, label %return_success, label %return_fail
return_success:
	ret i64 0
return_fail:
	ret i64 255
}

define i64 @prim_process_argc() {
	; load the fixnum tag and shift
	%fixnum_tag = load i64, i64* @prim_fixnum_tag
	%fixnum_shift = load i64, i64* @prim_fixnum_shift
	; make the fixnum
	%argc = load i64, i64* @argc
	%fixnum = shl i64 %argc, %fixnum_shift
	%tagged_fixnum = or i64 %fixnum, %fixnum_tag
	; return it
	ret i64 %tagged_fixnum
}

define i64 @prim_process_argv() {
	; get the args and prepare list creation
	%string_tag = load i64, i64* @prim_string_tag
	%argc = load i64, i64* @argc
	%argv = load i8**, i8*** @argv
	%empty_list = load i64, i64* @prim_pair_empty_list
	%current_index_ptr = alloca i64, align 8
	%current_pair_ptr = alloca i64, align 8
	%start_index = sub i64 %argc, 1
	; last list elements are the last element and the empty list
	%last_elem_ptrptr = getelementptr i8*, i8** %argv, i64 %start_index
	%last_elem_ptr = load i8*, i8** %last_elem_ptrptr
	%last_elem = call i64 @___reserved_heap_store_i8_array(i8* %last_elem_ptr)
	call i64 @___reserved_heap_store_i8(i8 0)
	call i64 @___reserved_heap_align()
	%tagged_last_elem = or i64 %last_elem, %string_tag
	%start_pair = call i64 @prim_pair_cons(i64 %tagged_last_elem, i64 %empty_list)
	store i64 %start_pair, i64* %current_pair_ptr
	%loop_start_index = sub i64 %start_index, 1
	store i64 %loop_start_index, i64* %current_index_ptr
	%start_index_is_zero = icmp eq i64 %start_index, 0
	br i1 %start_index_is_zero, label %return_list, label %args_list_loop
args_list_loop:
	%current_index = load i64, i64* %current_index_ptr
	%current_pair = load i64, i64* %current_pair_ptr
	%elem_ptrptr = getelementptr i8*, i8** %argv, i64 %current_index
	%elem_ptr = load i8*, i8** %elem_ptrptr
	%elem = call i64 @___reserved_heap_store_i8_array(i8* %elem_ptr)
	call i64 @___reserved_heap_store_i8(i8 0)
	call i64 @___reserved_heap_align()
	%tagged_elem = or i64 %elem, %string_tag
	%new_pair = call i64 @prim_pair_cons(i64 %tagged_elem, i64 %current_pair)
	%new_index = sub i64 %current_index, 1
	store i64 %new_index, i64* %current_index_ptr
	store i64 %new_pair, i64* %current_pair_ptr
	%current_index_is_zero = icmp eq i64 %current_index, 0
	br i1 %current_index_is_zero, label %return_list, label %args_list_loop
return_list:
	%res_pair = load i64, i64* %current_pair_ptr
	ret i64 %res_pair
}

define i64 @prim_process_exit(i64 %exit_code) {
	; get the fixnum shift
	%fixnum_shift = load i64, i64* @prim_fixnum_shift
	; remove the shift, truncate and call exit
	%unshifted_exit_code = lshr i64 %exit_code, %fixnum_shift
	%truncated_exit_code = trunc i64 %exit_code to i8
	call void @exit(i8 %truncated_exit_code)
	ret i64 0
}

define i64 @___reserved_has_tag(i64* %tag_ptr, i64* %mask_ptr, i64 %value) {
	%tag = load i64, i64* %tag_ptr
        %mask = load i64, i64* %mask_ptr
        %value_tag = and i64 %value, %mask
        %test = icmp eq i64 %value_tag, %tag
        br i1 %test, label %has_tag, label %has_not_tag
has_tag:
        %res_has_tag = load i64, i64* @prim_bool_true
        ret i64 %res_has_tag
has_not_tag:
        %res_has_not_tag = load i64, i64* @prim_bool_false
        ret i64 %res_has_not_tag
}

define i64 @___reserved_heap_store_i64(i64 %value) {
	; get the globals for the heap
	%base_ptr = load i8*, i8** @heap_base_ptr
	%index = load i64, i64* @heap_index
	; construct the current pointer and the integer
	; to be returned from it
	%i8_ptr = getelementptr i8, i8* %base_ptr, i64 %index
	%i64_ptr = bitcast i8* %i8_ptr to i64*
	%int_addr = ptrtoint i64* %i64_ptr to i64
	; store the value
	store i64 %value, i64* %i64_ptr, align 8
	; increment the heap index
	%new_index = add i64 %index, 8
	store i64 %new_index, i64* @heap_index
	; return the address stored to as an integer
	ret i64 %int_addr
}

define i64 @___reserved_store_i8(i8** %base_ptrptr, i64* %index_ptr, i8 %value) {
	; get the globals for the heap
	%base_ptr = load i8*, i8** %base_ptrptr
	%index = load i64, i64* %index_ptr
	; construct the current pointer and the integer
	; to be returned from it
	%i8_ptr = getelementptr i8, i8* %base_ptr, i64 %index
	%i64_ptr = bitcast i8* %i8_ptr to i64*
	%int_addr = ptrtoint i64* %i64_ptr to i64
	; store the value
	store i8 %value, i8* %i8_ptr
	; increment the heap index
	%new_index = add i64 %index, 1
	store i64 %new_index, i64* %index_ptr
	; return the address stored to as an integer
	ret i64 %int_addr
}

define i64 @___reserved_heap_store_i8(i8 %value) {
	%res = call i64 @___reserved_store_i8(i8** @heap_base_ptr, i64* @heap_index, i8 %value)
	ret i64 %res
}

define i64 @___reserved_symbols_store_i8(i8 %value) {
	%res = call i64 @___reserved_store_i8(i8** @symbols_base_ptr, i64* @symbols_index, i8 %value)
	ret i64 %res
}

define i64 @___reserved_align(i8** %base_ptrptr, i64* %index_ptr) {
	; get the globals for the heap
	%base_ptr = load i8*, i8** %base_ptrptr
	%index = load i64, i64* %index_ptr
	; compute and store the next aligned index
	%heap_mask = load i64, i64* @prim_heap_mask
	%misalignment = and i64 %index, %heap_mask
	%diff = sub i64 %heap_mask, %misalignment
	%fill = add i64 %diff, 1
	%next_index = add i64 %index, %fill
	store i64 %next_index, i64* %index_ptr
	; return the next aligned address
	%i8_ptr = getelementptr i8, i8* %base_ptr, i64 %next_index
	%i64_ptr = bitcast i8* %i8_ptr to i64*
	%int_addr = ptrtoint i64* %i64_ptr to i64
	ret i64 %int_addr
}

define i64 @___reserved_heap_align() {
	%res = call i64 @___reserved_align(i8** @heap_base_ptr, i64* @heap_index)
	ret i64 %res
}

define i64 @___reserved_symbols_align() {
	%res = call i64 @___reserved_align(i8** @symbols_base_ptr, i64* @symbols_index)
	ret i64 %res
}

define i64 @___reserved_store_i8_array(i8** %base_ptrptr, i64* %index_ptr, i8* %array_ptr) {
	; construct the current pointer and the integer
	; to be returned from it
	%base_ptr = load i8*, i8** %base_ptrptr
	%index = load i64, i64* %index_ptr
	%new_array_i8_ptr = getelementptr i8, i8* %base_ptr, i64 %index
	%new_array_i64_ptr = bitcast i8* %new_array_i8_ptr to i64*
	%new_array_addr = ptrtoint i64* %new_array_i64_ptr to i64
	%counter_ptr = alloca i64, align 8
	store i64 0, i64* %counter_ptr
	br label %copy_array_loop
copy_array_loop:
	%counter = load i64, i64* %counter_ptr
	%new_counter = add i64 %counter, 1
	store i64 %new_counter, i64* %counter_ptr
	%byte_ptr = getelementptr i8, i8* %array_ptr, i64 %counter
	%byte = load i8, i8* %byte_ptr
	%test_end = icmp eq i8 %byte, 0
	br i1 %test_end, label %return_addr, label %copy_byte
copy_byte:
	%dest_ptr = getelementptr i8, i8* %new_array_i8_ptr, i64 %counter
	store i8 %byte, i8* %dest_ptr
	br label %copy_array_loop
return_addr:
	%new_index = add i64 %index, %counter
	store i64 %new_index, i64* %index_ptr
	ret i64 %new_array_addr
}

define i64 @___reserved_heap_store_i8_array(i8* %array_ptr) {
	; store the array
	%new_array_addr = call i64 @___reserved_store_i8_array(i8** @heap_base_ptr, i64* @heap_index, i8* %array_ptr)
	ret i64 %new_array_addr
}

define i64 @___reserved_symbols_store_i8_array(i8* %array_ptr) {
	; store the array
	%new_array_addr = call i64 @___reserved_store_i8_array(i8** @symbols_base_ptr, i64* @symbols_index, i8* %array_ptr)
	ret i64 %new_array_addr
}

define i64 @___reserved_symbols_create(i8* %array_ptr) {
	; load the symbol tag and the heap mask
	%symbol_tag = load i64, i64* @prim_symbol_tag
	%heap_mask = load i64, i64* @prim_heap_mask
	; look for the symbol within the current symbols
	%base_ptr = load i8*, i8** @symbols_base_ptr
	%index = load i64, i64* @symbols_index
	%counter_ptr = alloca i64, align 8
	store i64 0, i64* %counter_ptr
	br label %find_symbol_loop
find_symbol_loop:
	%counter = load i64, i64* %counter_ptr
	%symbol_ptr = getelementptr i8, i8* %base_ptr, i64 %counter
	%symbol_len = call i64 @strlen(i8* %symbol_ptr)
	%tmp_counter = add i64 %counter, %symbol_len
	%new_counter = add i64 %tmp_counter, 1
	store i64 %new_counter, i64* %counter_ptr
	call i64 @___reserved_align(i8** @symbols_base_ptr, i64* %counter_ptr)
	%strcmp_equal = call i64 @strcmp(i8* %symbol_ptr, i8* %array_ptr)
	%test_equal = icmp eq i64 %strcmp_equal, 0
	br i1 %test_equal, label %symbol_present, label %symbol_not_yet_found
symbol_not_yet_found:
	%new_counter_aligned = load i64, i64* %counter_ptr
	%next_symbol_ptr = getelementptr i8, i8* %base_ptr, i64 %new_counter_aligned
	%next_symbol_first = load i8, i8* %next_symbol_ptr
	%test_zero = icmp eq i8 %next_symbol_first, 0
	br i1 %test_zero, label %symbol_not_present, label %find_symbol_loop
symbol_present:
	; if the symbol is already present, just return its address
	%symbol_i64_ptr = bitcast i8* %symbol_ptr to i64*
	%symbol_addr = ptrtoint i64* %symbol_i64_ptr to i64
	%tagged_symbol_addr = or i64 %symbol_addr, %symbol_tag
	ret i64 %tagged_symbol_addr
symbol_not_present:
	; otherwise store the symbol's string and return the address
	%new_symbol_addr = call i64 @___reserved_symbols_store_i8_array(i8* %array_ptr)
	call i64 @___reserved_symbols_store_i8(i8 0)
	call i64 @___reserved_symbols_align()
	%tagged_new_symbol_addr = or i64 %new_symbol_addr, %symbol_tag
	ret i64 %tagged_new_symbol_addr
}

