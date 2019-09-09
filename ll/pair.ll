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

define i64 @prim_is_pair(i64 %value) {
	%res = call i64 @___reserved_has_tag(i64* @prim_pair_tag, i64* @prim_heap_mask, i64 %value)
	ret i64 %res
}

define i64 @prim_is_null(i64 %value) {
        %res = call i64 @___reserved_has_tag(i64* @prim_pair_empty_list, i64* @prim_pair_empty_list_mask, i64 %value)
        ret i64 %res
}

define i64 @prim_is_list(i64 %value) {
	%bool_true = load i64, i64* @prim_bool_true
	%is_pair = call i64 @prim_is_pair(i64 %value)
	%pair_test = icmp eq i64 %is_pair, %bool_true
	br i1 %pair_test, label %check_cdr, label %check_null
check_cdr:
	%cdr = call i64 @prim_pair_cdr(i64 %value)
	%res_is_list = call i64 @prim_is_list(i64 %cdr)
	ret i64 %res_is_list
check_null:
	%res_is_empty_list = call i64 @prim_is_null(i64 %value)
	ret i64 %res_is_empty_list
}

define i64 @prim_pair_equal(i64 %x, i64 %y) {
	; check tag equality first
	%heap_mask = load i64, i64* @prim_heap_mask
	%x_tag = and i64 %x, %heap_mask
	%y_tag = and i64 %y, %heap_mask
	%tag_test = icmp eq i64 %x_tag, %y_tag
	br i1 %tag_test, label %check_pair_equality, label %not_equal
check_pair_equality:
	; get the cars and cdrs
	%x_car = call i64 @prim_pair_car(i64 %x)
	%x_cdr = call i64 @prim_pair_cdr(i64 %x)
	%y_car = call i64 @prim_pair_car(i64 %y)
	%y_cdr = call i64 @prim_pair_cdr(i64 %y)
	; check if the cars are equal and the cdrs are equal
	%cars_equal = call i64 @prim_generic_equal(i64 %x_car, i64 %y_car)
	%cdrs_equal = call i64 @prim_generic_equal(i64 %x_cdr, i64 %y_cdr)
	%both_equal = call i64 @prim_bool_and(i64 %cars_equal, i64 %cdrs_equal)
	; return the result
	ret i64 %both_equal
not_equal:
	%res_not_equal = load i64, i64* @prim_bool_false
	ret i64 %res_not_equal
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
