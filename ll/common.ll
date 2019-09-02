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
declare i8* @calloc(i32, i32)
declare void @free(i8*)

declare i64 @puts(i8*);
declare i64 @putchar(i8);
declare i64 @strlen(i8*);
declare i64 @strcmp(i8*, i8*);
declare i64 @snprintf(i8*, i64, i8*, ...);

; basic heap management
@heap_base_ptr = global i8* zeroinitializer, align 8
@heap_index = global i64 0, align 8

; basic data type management
@prim_bool_true = global i64 159
@prim_bool_false = global i64 31
@prim_bool_mask = global i64 127
@prim_bool_tag = global i64 31

@prim_pair_empty_list = global i64 47
@prim_pair_empty_list_mask = global i64 255

@prim_fixnum_tag = global i64 0
@prim_fixnum_shift = global i64 2
@prim_fixnum_mask = global i64 3

@prim_heap_shift = global i64 3
@prim_heap_mask = global i64 7

@prim_pair_tag = global i64 1
@prim_vector_tag = global i64 2
@prim_string_tag = global i64 3
@prim_symbol_tag = global i64 5
@prim_closure_tag = global i64 6

define i64 @___reserved_main() {
	; allocate the heap and store its pointer
	%heap_ptr = call i8* @calloc(i32 10000, i32 8)
	store i8* %heap_ptr, i8** @heap_base_ptr, align 8
	; call the main program
	%res = call i64 @scheme_main()
	; free the heap
	call void @free(i8* %heap_ptr)
	; return the result from the main program
	ret i64 %res
}

;define i64 @main() {
;	%res = call i64 @___reserved_main()
;	ret i64 %res
;}

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

define i64 @___reserved_heap_store_i8(i8 %value) {
	; get the globals for the heap
	%base_ptr = load i8*, i8** @heap_base_ptr
	%index = load i64, i64* @heap_index
	; construct the current pointer and the integer
	; to be returned from it
	%i8_ptr = getelementptr i8, i8* %base_ptr, i64 %index
	%i64_ptr = bitcast i8* %i8_ptr to i64*
	%int_addr = ptrtoint i64* %i64_ptr to i64
	; store the value
	store i8 %value, i8* %i8_ptr
	; increment the heap index
	%new_index = add i64 %index, 1
	store i64 %new_index, i64* @heap_index
	; return the address stored to as an integer
	ret i64 %int_addr
}

define i64 @___reserved_heap_align() {
	; get the globals for the heap
	%base_ptr = load i8*, i8** @heap_base_ptr
	%index = load i64, i64* @heap_index
	; compute and store the next aligned index
	%heap_mask = load i64, i64* @prim_heap_mask
	%misalignment = and i64 %index, %heap_mask
	%diff = sub i64 %heap_mask, %misalignment
	%fill = add i64 %diff, 1
	%next_index = add i64 %index, %fill
	store i64 %next_index, i64* @heap_index
	; return the next aligned address
	%i8_ptr = getelementptr i8, i8* %base_ptr, i64 %next_index
	%i64_ptr = bitcast i8* %i8_ptr to i64*
	%int_addr = ptrtoint i64* %i64_ptr to i64
	ret i64 %int_addr
}

define i64 @___reserved_heap_store_i8_array(i8* %array_ptr) {
	%new_array_addr = call i64 @___reserved_heap_store_i8(i8 0)
	%new_array_ptr = inttoptr i64 %new_array_addr to i64*
	%new_array_i8_ptr = bitcast i64* %new_array_ptr to i8*
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
	call i64 @___reserved_heap_store_i8(i8 0)
	br label %copy_array_loop
return_addr:
	ret i64 %new_array_addr
}
