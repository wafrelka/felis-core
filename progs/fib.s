fib.9:
	addi	r0 r2 1
	sub	r1 r2 r25
	blez	r25 ble_tail_else.24
	addi	r0 r2 1
	sub	r1 r2 r2
	sw	r1 r30 0
	sw	r31 r30 4
	addi	r30 r30 8
	mov	r1 r2
	jal	fib.9
	addi	r30 r30 -8
	lw	r30 r31 4
	addi	r0 r2 2
	lw	r30 r3 0
	sub	r3 r2 r2
	sw	r1 r30 4
	sw	r31 r30 8
	addi	r30 r30 12
	mov	r1 r2
	jal	fib.9
	addi	r30 r30 -12
	lw	r30 r31 8
	lw	r30 r2 4
	add	r2 r1 r1
	jr	r31
ble_tail_else.24:
	addi	r0 r1 1
	jr	r31
_min_caml_start:
	lui	r27 32
	addi	r0 r1 10
	sw	r31 r30 0
	addi	r30 r30 4
	jal	fib.9
	addi	r30 r30 -4
	lw	r30 r31 0
	sw	r31 r30 0
	addi	r30 r30 4
	jal	min_caml_print_int
	addi	r30 r30 -4
	lw	r30 r31 0
halt
