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

declare i8* @calloc(i32, i32)
declare void @free(i8*)

declare i64 @puts(i8*);

@heap_base_ptr = global i8* zeroinitializer, align 8
@heap_index = global i64 0, align 8

@prim_bool_true = global i64 159
@prim_bool_false = global i64 31

@prim_pair_empty_list = global i64 47

@prim_heap_shift = global i64 3

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

