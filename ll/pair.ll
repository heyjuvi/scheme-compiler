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

define i64 @prim_list_ref(i64 %start_pair, i64 %index) {
	%res = add i64 0, 0
	; return the list element
	ret i64 %res
}
