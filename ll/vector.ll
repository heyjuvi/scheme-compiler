; structur of vector:
; i64 %size | i64 %elem_0 | i64 %elem_1 | ...

define i64 @prim_vector_init(i64 %size) {
	; store the size of the vector
	%vector_addr = call i64 @___reserved_heap_store_i64(i64 %size)
	; remove the tag of size
        %fixnum_shift = load i64, i64* @prim_fixnum_shift
        %untagged_size = lshr i64 %size, %fixnum_shift
	; create a counter for the loop
	%counter_ptr = alloca i64, align 8
	store i64 %untagged_size, i64* %counter_ptr
	br label %reserve_memory
reserve_memory:
	call i64 @___reserved_heap_store_i64(i64 0)
	%counter = load i64, i64* %counter_ptr
	%new_counter = sub i64 %counter, 1
	store i64 %new_counter, i64* %counter_ptr
	%test = icmp eq i64 %new_counter, 0
	br i1 %test, label %return_vector, label %reserve_memory
return_vector:
	; set the vector tag
        %vector_tag = load i64, i64* @prim_vector_tag
        %tagged_vector_addr = or i64 %vector_addr, %vector_tag
	; return the freshly created vector
	ret i64 %tagged_vector_addr
}

define i64 @prim_vector_ref(i64 %vector, i64 %index) {
	; remove the tag of vector
        %vector_tag = load i64, i64* @prim_vector_tag
        %vector_addr = xor i64 %vector, %vector_tag
	; remove the tag of index
        %fixnum_shift = load i64, i64* @prim_fixnum_shift
        %untagged_index = lshr i64 %index, %fixnum_shift
	; get a pointer to the desired element
	%vector_ptr = inttoptr i64 %vector_addr to i64*
	%data_index = add i64 %untagged_index, 1
	%elem_ptr = getelementptr i64, i64* %vector_ptr, i64 %data_index
	; return the element
	%elem = load i64, i64* %elem_ptr
	ret i64 %elem
}

define i64 @prim_vector_set(i64 %vector, i64 %index, i64 %value) {
	; remove the tag of vector
        %vector_tag = load i64, i64* @prim_vector_tag
        %vector_addr = xor i64 %vector, %vector_tag
	; remove the tag of index
        %fixnum_shift = load i64, i64* @prim_fixnum_shift
        %untagged_index = lshr i64 %index, %fixnum_shift
	; get a pointer to the desired element
	%vector_ptr = inttoptr i64 %vector_addr to i64*
	%data_index = add i64 %untagged_index, 1
	%elem_ptr = getelementptr i64, i64* %vector_ptr, i64 %data_index
	; set the element
	store i64 %value, i64* %elem_ptr
	; just return true
	%res_true = load i64, i64* @prim_bool_true
	ret i64 %res_true
}

