; structure of a port:
; a vector with the fields
; i64 %port_type, i64% file_desc

@prim_port_in_type = global i64 0, align 8
@prim_port_out_type = global i64 1, align 8
@prim_port_in_out_type = global i64 2, align 8

@prim_port_read = private constant [2 x i8] c"r\00", align 8
@prim_port_write = private constant [2 x i8] c"w\00", align 8
@prim_port_read_write = private constant [3 x i8] c"r+\00", align 8

@prim_port_eof_object = global i64 16776975, align 8

define i64 @___reserved_port_open_file(i64 %path, i64* %type_ptr) {
	; create the port
	%port = call i64 @prim_vector_init(i64 2)
	; get the type value
	%type = load i64, i64* %type_ptr
	; get the pointer of path
	%string_tag = load i64, i64* @prim_string_tag
	%string_addr = xor i64 %path, %string_tag
	%string_i64_ptr = inttoptr i64 %string_addr to i64*
	%string_ptr = bitcast i64* %string_i64_ptr to i8*
	; open the file
	%file_handle_ptrptr = alloca i64*, align 8
	%is_in_type = icmp eq i64* %type_ptr, @prim_port_in_type
	br i1 %is_in_type, label %open_in_type, label %check_out_type
open_in_type:
	%file_read_handle_ptr = call i64* @fopen(i8* %string_ptr, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @prim_port_read, i64 0, i64 0))
	store i64* %file_read_handle_ptr, i64** %file_handle_ptrptr
	br label %create_port
check_out_type:
	%is_out_type = icmp eq i64* %type_ptr, @prim_port_out_type
	br i1 %is_out_type, label %open_out_type, label %check_in_out_type
open_out_type:
	%file_write_handle_ptr = call i64* @fopen(i8* %string_ptr, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @prim_port_write, i64 0, i64 0))
	store i64* %file_write_handle_ptr, i64** %file_handle_ptrptr
	br label %create_port
check_in_out_type:
	%is_in_out_type = icmp eq i64* %type_ptr, @prim_port_in_out_type
	br i1 %is_in_out_type, label %open_in_out_type, label %check_in_out_type
open_in_out_type:
	%file_read_write_handle_ptr = call i64* @fopen(i8* %string_ptr, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @prim_port_read_write, i64 0, i64 0))
	store i64* %file_read_write_handle_ptr, i64** %file_handle_ptrptr
	br label %create_port
create_port:
	%file_handle_ptr = load i64*, i64** %file_handle_ptrptr
	%file_handle_addr = ptrtoint i64* %file_handle_ptr to i64
	; set the ports data
	call i64 @prim_vector_set(i64 %port, i64 0, i64 %type)
	call i64 @prim_vector_set(i64 %port, i64 1, i64 %file_handle_addr)
	ret i64 %port
}

define i64 @prim_port_open_input_file(i64 %path) {
	%res = call i64 @___reserved_port_open_file(i64 %path, i64* @prim_port_in_type)
	ret i64 %res
}

define i64 @prim_port_open_output_file(i64 %path) {
	%res = call i64 @___reserved_port_open_file(i64 %path, i64* @prim_port_out_type)
	ret i64 %res
}

define i64 @prim_port_open_i_o_file(i64 %path) {
	%res = call i64 @___reserved_port_open_file(i64 %path, i64* @prim_port_in_out_type)
	ret i64 %res
}

define i64 @prim_port_is_eof_object(i64 %char) {
	%eof_object = load i64, i64* @prim_port_eof_object
	%res = call i64 @prim_generic_eq(i64 %char, i64 %eof_object)
	ret i64 %res
}

define i64 @prim_port_read_char(i64 %port) {
	; get the char tag, shift and the eof object
	%char_tag = load i64, i64* @prim_char_tag
	%char_shift = load i64, i64* @prim_char_shift
	%eof_object = load i64, i64* @prim_port_eof_object
	; get the file handle
	%file_handle_addr = call i64 @prim_vector_ref(i64 %port, i64 1)
	%file_handle_ptr = inttoptr i64 %file_handle_addr to i64*
	; read a char
	%unshifted_char = call i64 @fgetc(i64* %file_handle_ptr)
	; TODO: this works only on linux?
	%test_eof = icmp uge i64 %unshifted_char, 65535
	br i1 %test_eof, label %return_eof_object, label %return_char
return_eof_object:
	ret i64 %eof_object
return_char:
	%char = shl i64 %unshifted_char, %char_shift
	%tagged_char = or i64 %char, %char_tag
	ret i64 %tagged_char
}
