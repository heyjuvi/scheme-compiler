; structure of pair:
; i64 %x | i64 %y

define i64 @prim_pair_cons(i64 %x, i64 %y) {
	; store the elements on the heap
	%pair_addr = call i64 @___reserved_heap_store_i64(i64 %x)
	call i64 @___reserved_heap_store_i64(i64 %y)
	; set the pair tag
	%pair_tag = load i64, i64* @prim_pair_tag
	%tagged_pair_addr = or i64 %pair_addr, %pair_tag
	; return the tagged pair
	ret i64 %tagged_pair_addr
}

define i64 @prim_pair_car(i64 %pair) {
	; remove the tag
	%pair_tag = load i64, i64* @prim_pair_tag
	%pair_addr = xor i64 %pair, %pair_tag
	; make a pointer from it
	%pair_ptr = inttoptr i64 %pair_addr to i64*
	; get the car
	%car_ptr = getelementptr i64, i64* %pair_ptr, i64 0
	%car = load i64, i64* %car_ptr
	; return the car
	ret i64 %car
}

define i64 @prim_pair_cdr(i64 %pair) {
	; remove the tag
	%pair_tag = load i64, i64* @prim_pair_tag
	%pair_addr = xor i64 %pair, %pair_tag
	; make a pointer from it
	%pair_ptr = inttoptr i64 %pair_addr to i64*
	; get the cdr
	%cdr_ptr = getelementptr i64, i64* %pair_ptr, i64 1
	%cdr = load i64, i64* %cdr_ptr
	; return the cdr
	ret i64 %cdr
}

define i64 @prim_list_ref(i64 %start_pair, i64 %tagged_index) {
	; get the value for empty list
	%empty_list = load i64, i64* @prim_pair_empty_list
	; create a pair to hold the current one while processing the list
	%current_pair_ptr = alloca i64, align 8
	store i64 %start_pair, i64* %current_pair_ptr
	; create an index to iterate until it reaches 0
	%current_index_ptr = alloca i64, align 8
	%index = lshr i64 %tagged_index, 2
	store i64 %index, i64* %current_index_ptr
	; jump into the loop block
	br label %loop_start
loop_start:
	; load the current_pair and the current_index
	%current_pair = load i64, i64* %current_pair_ptr
	%current_index = load i64, i64* %current_index_ptr
	; if the index is 0 we return the first element
	%is_zero = icmp eq i64 %current_index, 0
	br i1 %is_zero, label %zero_index_conseq, label %zero_index_altern
zero_index_conseq:
	; return the found element
	%res_element = call i64 @prim_pair_car(i64 %current_pair)
	ret i64 %res_element
zero_index_altern:
	; if the cdr of current_pair is the empty list this is an error case,
	; else we continue trying to find the indexed element
	%next_pair = call i64 @prim_pair_cdr(i64 %current_pair)
	%is_empty_list = icmp eq i64 %next_pair, %empty_list
	br i1 %is_empty_list, label %empty_list_conseq, label %empty_list_altern
empty_list_conseq:
	; TODO: make an error
	%res_not_found = load i64, i64* @prim_bool_false
	ret i64 %res_not_found
empty_list_altern:
	; store next_pair and next_current_index for the following loop iteration
	store i64 %next_pair, i64* %current_pair_ptr
	%next_current_index = sub i64 %current_index, 1
	store i64 %next_current_index, i64* %current_index_ptr
	br label %loop_start
}
