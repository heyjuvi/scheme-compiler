define i64 @prim_closure(i64 %func_addr, i64 %env) {
	; store the function address on the heap
	%closure_addr = call i64 @___reserved_heap_store_i64(i64 %func_addr)
	; store the closure's environment (which itself is a list) on the heap
	call i64 @___reserved_heap_store_i64(i64 %env)
	; set the closure tag
	%closure_tag = load i64, i64* @prim_closure_tag
	%tagged_closure_addr = or i64 %closure_addr, %closure_tag
	; return the tagged closure
	ret i64 %tagged_closure_addr
}

define i64 @prim_closure_func_addr(i64 %closure) {
	; remove the tag
	%closure_tag = load i64, i64* @prim_closure_tag
	%closure_addr = xor i64 %closure, %closure_tag
	; make a pointer from it
	%closure_ptr = inttoptr i64 %closure_addr to i64*
	; get the function address
	%func_addr_ptr = getelementptr i64, i64* %closure_ptr, i64 0
	%func_addr = load i64, i64* %func_addr_ptr
	; return the function address
	ret i64 %func_addr
}

define i64 @prim_closure_env(i64 %closure) {
	; remove the tag
	%closure_tag = load i64, i64* @prim_closure_tag
	%closure_addr = xor i64 %closure, %closure_tag
	; make a pointer from it
	%closure_ptr = inttoptr i64 %closure_addr to i64*
	; get the environment
	%env_ptr = getelementptr i64, i64* %closure_ptr, i64 1
	%env = load i64, i64* %env_ptr
	; return the environment
	ret i64 %env
}

