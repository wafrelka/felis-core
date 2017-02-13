min_caml_print_char:
	out r1
	jr r31

min_caml_print_int:
	addi r1 r25 0
	addi r0 r2 10
	addi r0 r3 1
	bgez r25 _io_print_int_get_num_digits
	sub r0 r1 r1
	addi r0 r4 45
	out r4
	j min_caml_print_int
_io_print_int_get_num_digits:
	sub r1 r2 r25
	bltz r25 _io_print_int_loop
	multi r2 r2 10
	addi r3 r3 1
	j _io_print_int_get_num_digits
_io_print_int_loop:
	addi r3 r25 0
	beq r25 r0 _io_print_int_return
	divi r2 r2 10
	addi r3 r3 -1
	div r1 r2 r4
	mult r2 r4 r5
	sub r1 r5 r1
	addi r4 r4 48
	out r4
	j _io_print_int_loop
_io_print_int_return:
	jr r31
min_caml_read_int:
	addi r0 r1 0 # res
	addi r0 r2 0 # read?
	addi r0 r3 0 # sgn
_io_read_int_loop:
	in r4
	addi r4 r25 -32
	blez r25 _io_read_int_check_end
	addi r4 r25 -45
	beq r25 r0 _io_read_int_change_sgn
	addi r4 r25 -43
	beq r25 r0 _io_read_int_loop
	addi r4 r4 -48
	multi r1 r1 10
	add r1 r4 r1
	addi r0 r2 1
	j _io_read_int_loop
_io_read_int_change_sgn:
	addi r3 r3 1
	j _io_read_int_loop
_io_read_int_check_end:
	add r2 r0 r25
	beq r25 r0 _io_read_int_loop
	andi r3 r3 1
	addi r3 r25 -1
	bltz r25 _io_read_int_return
	sub r0 r1 r1
_io_read_int_return:
	jr r31

min_caml_read_float:
	addi r0 r2 0 # read?
	addi r0 r3 0 # sgn
	addi r0 r5 0 # integer part
	addi r0 r6 0 # decimal part
	addi r0 r7 0 # #decimal digits
	addi r0 r8 10 # ten
	mtc1 r0 f0
	mtc1 r0 f1
	mtc1 r8 f31
	cvt.s.w f31 f2 # f2 = 10.0
_io_read_float_integer_part:
	in r4
	addi r4 r25 -32
	blez r25 _io_read_float_check_end
	addi r4 r25 -45 # '-'
	beq r25 r0 _io_read_float_change_sgn
	addi r4 r25 -43 # '+'
	beq r25 r0 _io_read_float_integer_part
	addi r4 r25 -46 # '.'
	beq r25 r0 _io_read_float_decimal_part
	addi r4 r4 -48
	multi r5 r5 10
	add r5 r4 r5
	addi r0 r2 1
	j _io_read_float_integer_part
_io_read_float_change_sgn:
	addi r3 r3 1
	j _io_read_float_integer_part
_io_read_float_decimal_part:
	in r4
	addi r4 r25 -32
	blez r25 _io_read_float_check_end
	addi r4 r4 -48
	multi r6 r6 10
	add r6 r4 r6
	addi r7 r7 1
	j _io_read_float_decimal_part
_io_read_float_check_end:
	addi r2 r25 0
	beq r25 r0 _io_read_float_integer_part
	mtc1 r5 f31
	cvt.s.w f31 f0
	mtc1 r6 f31
	cvt.s.w f31 f1
_io_read_float_divide_decimal:
	addi r7 r25 0
	beq r25 r0 _io_read_float_adapt_sgn
	addi r7 r7 -1
	div.s f1 f2 f1
	j _io_read_float_divide_decimal
_io_read_float_adapt_sgn:
	add.s f0 f1 f0
	andi r3 r3 1
	addi r3 r25 -1
	bltz r25 _io_read_float_return
	neg.s f0 f0
_io_read_float_return:
	jr r31
