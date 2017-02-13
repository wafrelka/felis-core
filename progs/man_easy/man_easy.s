min_caml_create_array:
test/mandelbrot/array.smin_caml_create_array:
addi r1 r3 0
addi r1 r1 -1
sll r1 r1 2
test/mandelbrot/array.s_create_array_loop:
swo r2 r27 r1
beq r1 r0 test/mandelbrot/array.s_create_array_return
addi r1 r1 -4
j test/mandelbrot/array.s_create_array_loop
test/mandelbrot/array.s_create_array_return:
sll r3 r3 2
addi r27 r1 0
add r27 r3 r27
jr r31
min_caml_create_float_array:
test/mandelbrot/array.smin_caml_create_float_array:
addi r1 r3 0
addi r1 r1 -1
sll r1 r1 2
test/mandelbrot/array.s_create_float_array_loop:
swoc1 f0 r27 r1
beq r1 r0 test/mandelbrot/array.s_create_float_array_return
addi r1 r1 -4
j test/mandelbrot/array.s_create_float_array_loop
test/mandelbrot/array.s_create_float_array_return:
sll r3 r3 2
addi r27 r1 0
add r27 r3 r27
jr r31
min_caml_print_char:
test/mandelbrot/io.smin_caml_print_char:
out r1
jr r31
min_caml_print_int:
test/mandelbrot/io.smin_caml_print_int:
addi r1 r25 0
addi r0 r2 10
addi r0 r3 1
bgez r25 test/mandelbrot/io.s_io_print_int_get_num_digits
sub r0 r1 r1
addi r0 r4 45
out r4
j min_caml_print_int
test/mandelbrot/io.s_io_print_int_get_num_digits:
sub r1 r2 r25
bltz r25 test/mandelbrot/io.s_io_print_int_loop
multi r2 r2 10
addi r3 r3 1
j test/mandelbrot/io.s_io_print_int_get_num_digits
test/mandelbrot/io.s_io_print_int_loop:
addi r3 r25 0
beq r25 r0 test/mandelbrot/io.s_io_print_int_return
divi r2 r2 10
addi r3 r3 -1
div r1 r2 r4
mult r2 r4 r5
sub r1 r5 r1
addi r4 r4 48
out r4
j test/mandelbrot/io.s_io_print_int_loop
test/mandelbrot/io.s_io_print_int_return:
jr r31
min_caml_read_int:
test/mandelbrot/io.smin_caml_read_int:
addi r0 r1 0
addi r0 r2 0
addi r0 r3 0
test/mandelbrot/io.s_io_read_int_loop:
in r4
addi r4 r25 -32
blez r25 test/mandelbrot/io.s_io_read_int_check_end
addi r4 r25 -45
beq r25 r0 test/mandelbrot/io.s_io_read_int_change_sgn
addi r4 r25 -43
beq r25 r0 test/mandelbrot/io.s_io_read_int_loop
addi r4 r4 -48
multi r1 r1 10
add r1 r4 r1
addi r0 r2 1
j test/mandelbrot/io.s_io_read_int_loop
test/mandelbrot/io.s_io_read_int_change_sgn:
addi r3 r3 1
j test/mandelbrot/io.s_io_read_int_loop
test/mandelbrot/io.s_io_read_int_check_end:
add r2 r0 r25
beq r25 r0 test/mandelbrot/io.s_io_read_int_loop
andi r3 r3 1
addi r3 r25 -1
bltz r25 test/mandelbrot/io.s_io_read_int_return
sub r0 r1 r1
test/mandelbrot/io.s_io_read_int_return:
jr r31
min_caml_read_float:
test/mandelbrot/io.smin_caml_read_float:
addi r0 r2 0
addi r0 r3 0
addi r0 r5 0
addi r0 r6 0
addi r0 r7 0
addi r0 r8 10
mtc1 r0 f0
mtc1 r0 f1
mtc1 r8 f31
cvt.s.w f31 f2
test/mandelbrot/io.s_io_read_float_integer_part:
in r4
addi r4 r25 -32
blez r25 test/mandelbrot/io.s_io_read_float_check_end
addi r4 r25 -45
beq r25 r0 test/mandelbrot/io.s_io_read_float_change_sgn
addi r4 r25 -43
beq r25 r0 test/mandelbrot/io.s_io_read_float_integer_part
addi r4 r25 -46
beq r25 r0 test/mandelbrot/io.s_io_read_float_decimal_part
addi r4 r4 -48
multi r5 r5 10
add r5 r4 r5
addi r0 r2 1
j test/mandelbrot/io.s_io_read_float_integer_part
test/mandelbrot/io.s_io_read_float_change_sgn:
addi r3 r3 1
j test/mandelbrot/io.s_io_read_float_integer_part
test/mandelbrot/io.s_io_read_float_decimal_part:
in r4
addi r4 r25 -32
blez r25 test/mandelbrot/io.s_io_read_float_check_end
addi r4 r4 -48
multi r6 r6 10
add r6 r4 r6
addi r7 r7 1
j test/mandelbrot/io.s_io_read_float_decimal_part
test/mandelbrot/io.s_io_read_float_check_end:
addi r2 r25 0
beq r25 r0 test/mandelbrot/io.s_io_read_float_integer_part
mtc1 r5 f31
cvt.s.w f31 f0
mtc1 r6 f31
cvt.s.w f31 f1
test/mandelbrot/io.s_io_read_float_divide_decimal:
addi r7 r25 0
beq r25 r0 test/mandelbrot/io.s_io_read_float_adapt_sgn
addi r7 r7 -1
div.s f1 f2 f1
j test/mandelbrot/io.s_io_read_float_divide_decimal
test/mandelbrot/io.s_io_read_float_adapt_sgn:
add.s f0 f1 f0
andi r3 r3 1
addi r3 r25 -1
bltz r25 test/mandelbrot/io.s_io_read_float_return
neg.s f0 f0
test/mandelbrot/io.s_io_read_float_return:
jr r31
test/mandelbrot/man_easy.swrite_header.193:
addi r0 r1 80
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_char
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 51
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_char
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 10
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_char
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 400
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_int
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 32
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_char
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 400
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_int
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 32
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_char
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 255
sw r31 r30 0
addi r30 r30 4
jal min_caml_print_int
addi r30 r30 -4
lw r30 r31 0
addi r0 r1 10
j min_caml_print_char
test/mandelbrot/man_easy.swrite_rgb.196:
lw r29 r2 4
addi r0 r3 3
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.476
addi r0 r3 4
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.478
addi r0 r3 5
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.480
addi r0 r3 7
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.482
addi r0 r3 9
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.484
addi r0 r3 12
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.486
addi r0 r3 15
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.488
addi r0 r3 20
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.490
addi r0 r3 25
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.492
addi r0 r3 35
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.494
addi r0 r3 45
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.496
addi r0 r3 60
sub r1 r3 r25
blez r25 test/mandelbrot/man_easy.sble_nontail_else.498
addi r0 r1 0
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
j test/mandelbrot/man_easy.sble_nontail_cont.499
test/mandelbrot/man_easy.sble_nontail_else.498:
addi r0 r1 0
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 127
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.499:
j test/mandelbrot/man_easy.sble_nontail_cont.497
test/mandelbrot/man_easy.sble_nontail_else.496:
addi r0 r1 0
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.497:
j test/mandelbrot/man_easy.sble_nontail_cont.495
test/mandelbrot/man_easy.sble_nontail_else.494:
addi r0 r1 0
addi r0 r3 127
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.495:
j test/mandelbrot/man_easy.sble_nontail_cont.493
test/mandelbrot/man_easy.sble_nontail_else.492:
addi r0 r1 0
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.493:
j test/mandelbrot/man_easy.sble_nontail_cont.491
test/mandelbrot/man_easy.sble_nontail_else.490:
addi r0 r1 0
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 127
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.491:
j test/mandelbrot/man_easy.sble_nontail_cont.489
test/mandelbrot/man_easy.sble_nontail_else.488:
addi r0 r1 0
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.489:
j test/mandelbrot/man_easy.sble_nontail_cont.487
test/mandelbrot/man_easy.sble_nontail_else.486:
addi r0 r1 0
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 127
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.487:
j test/mandelbrot/man_easy.sble_nontail_cont.485
test/mandelbrot/man_easy.sble_nontail_else.484:
addi r0 r1 0
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.485:
j test/mandelbrot/man_easy.sble_nontail_cont.483
test/mandelbrot/man_easy.sble_nontail_else.482:
addi r0 r1 0
addi r0 r3 127
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.483:
j test/mandelbrot/man_easy.sble_nontail_cont.481
test/mandelbrot/man_easy.sble_nontail_else.480:
addi r0 r1 0
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.481:
j test/mandelbrot/man_easy.sble_nontail_cont.479
test/mandelbrot/man_easy.sble_nontail_else.478:
addi r0 r1 0
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 127
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.479:
j test/mandelbrot/man_easy.sble_nontail_cont.477
test/mandelbrot/man_easy.sble_nontail_else.476:
addi r0 r1 0
addi r0 r3 255
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 1
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
addi r0 r1 2
addi r0 r3 0
sll r1 r1 2
swo r3 r2 r1
test/mandelbrot/man_easy.sble_nontail_cont.477:
addi r0 r1 32
sw r2 r30 0
sw r31 r30 4
addi r30 r30 8
jal min_caml_print_char
addi r30 r30 -8
lw r30 r31 4
addi r0 r1 0
sll r1 r1 2
lw r30 r2 0
lwo r2 r1 r1
sw r31 r30 4
addi r30 r30 8
jal min_caml_print_int
addi r30 r30 -8
lw r30 r31 4
addi r0 r1 32
sw r31 r30 4
addi r30 r30 8
jal min_caml_print_char
addi r30 r30 -8
lw r30 r31 4
addi r0 r1 1
sll r1 r1 2
lw r30 r2 0
lwo r2 r1 r1
sw r31 r30 4
addi r30 r30 8
jal min_caml_print_int
addi r30 r30 -8
lw r30 r31 4
addi r0 r1 32
sw r31 r30 4
addi r30 r30 8
jal min_caml_print_char
addi r30 r30 -8
lw r30 r31 4
addi r0 r1 2
sll r1 r1 2
lw r30 r2 0
lwo r2 r1 r1
j min_caml_print_int
test/mandelbrot/man_easy.siloop.216:
lw r29 r2 4
addi r0 r3 256
sub r3 r1 r25
blez r25 test/mandelbrot/man_easy.sble_tail_else.500
mul.s f0 f0 f4
mul.s f1 f1 f5
sub.s f4 f5 f4
add.s f4 f2 f4
lui r24 16384
ori r24 r24 0
mtc1 r24 f5
mul.s f5 f0 f5
mul.s f5 f1 f5
add.s f5 f3 f5
mul.s f0 f0 f0
mul.s f1 f1 f1
add.s f0 f1 f0
lui r24 16512
ori r24 r24 0
mtc1 r24 f1
sub.s f0 f1 f30
mfc1 f30 r25
blez r25 test/mandelbrot/man_easy.sbfle_tail_else.501
mov r29 r2
lw r29 r23 0
sll r23 r23 2
j r23
test/mandelbrot/man_easy.sbfle_tail_else.501:
addi r0 r2 1
add r1 r2 r1
mov.s f5 f1
mov.s f4 f0
lw r29 r23 0
sll r23 r23 2
j r23
test/mandelbrot/man_easy.sble_tail_else.500:
addi r0 r1 256
mov r29 r2
lw r29 r23 0
sll r23 r23 2
j r23
test/mandelbrot/man_easy.sxloop.204:
lw r29 r3 4
addi r0 r4 400
sub r4 r1 r25
blez r25 test/mandelbrot/man_easy.sble_tail_else.502
sw r29 r30 0
sw r1 r30 4
sw r3 r30 8
sw r2 r30 12
sw r31 r30 16
addi r30 r30 20
jal min_caml_float_of_int
addi r30 r30 -20
lw r30 r31 16
lw r30 r1 12
swc1 f0 r30 16
sw r31 r30 20
addi r30 r30 24
jal min_caml_float_of_int
addi r30 r30 -24
lw r30 r31 20
lui r24 17224
ori r24 r24 0
mtc1 r24 f1
lwc1 r30 f2 16
div.s f2 f1 f1
lui r24 16320
ori r24 r24 0
mtc1 r24 f2
sub.s f1 f2 f2
lui r24 17224
ori r24 r24 0
mtc1 r24 f1
div.s f0 f1 f0
lui r24 16256
ori r24 r24 0
mtc1 r24 f1
sub.s f0 f1 f3
mov r29 r27
addi r27 r27 8
addi r0 r1 test/mandelbrot/man_easy.siloop.216
sw r1 r29 0
lw r30 r1 8
sw r1 r29 4
addi r0 r1 0
lui r24 0
ori r24 r24 0
mtc1 r24 f0
lui r24 0
ori r24 r24 0
mtc1 r24 f1
lw r29 r23 0
sw r31 r30 20
addi r30 r30 24
sll r23 r23 2
jal r23
addi r30 r30 -24
lw r30 r31 20
addi r0 r1 1
lw r30 r2 4
add r2 r1 r1
lw r30 r2 12
lw r30 r29 0
lw r29 r23 0
sll r23 r23 2
j r23
test/mandelbrot/man_easy.sble_tail_else.502:
jr r31
test/mandelbrot/man_easy.syloop.198:
lw r29 r2 4
addi r0 r3 400
sub r3 r1 r25
blez r25 test/mandelbrot/man_easy.sble_tail_else.504
mov r3 r27
addi r27 r27 8
addi r0 r4 test/mandelbrot/man_easy.sxloop.204
sw r4 r3 0
sw r2 r3 4
addi r0 r2 0
sw r29 r30 0
sw r1 r30 4
mov r29 r3
mov r28 r2
mov r2 r1
mov r1 r28
lw r29 r23 0
sw r31 r30 8
addi r30 r30 12
sll r23 r23 2
jal r23
addi r30 r30 -12
lw r30 r31 8
addi r0 r1 1
lw r30 r2 4
add r2 r1 r1
lw r30 r29 0
lw r29 r23 0
sll r23 r23 2
j r23
test/mandelbrot/man_easy.sble_tail_else.504:
jr r31
_min_caml_start:
test/mandelbrot/man_easy.s_min_caml_start:
lui r27 32
addi r0 r1 3
addi r0 r2 0
sw r31 r30 0
addi r30 r30 4
jal min_caml_create_array
addi r30 r30 -4
lw r30 r31 0
mov r2 r27
addi r27 r27 8
addi r0 r3 test/mandelbrot/man_easy.swrite_rgb.196
sw r3 r2 0
sw r1 r2 4
mov r1 r27
addi r27 r27 8
addi r0 r3 test/mandelbrot/man_easy.syloop.198
sw r3 r1 0
sw r2 r1 4
sw r1 r30 0
sw r31 r30 4
addi r30 r30 8
jal test/mandelbrot/man_easy.swrite_header.193
addi r30 r30 -8
lw r30 r31 4
addi r0 r1 0
lw r30 r29 0
lw r29 r23 0
sw r31 r30 4
addi r30 r30 8
sll r23 r23 2
jal r23
addi r30 r30 -8
lw r30 r31 4
halt
min_caml_floor:
test/mandelbrot/math_primitive.smin_caml_floor:
cvt.w.s f0 f0
cvt.s.w f0 f0
jr r31
min_caml_floor_retint:
test/mandelbrot/math_primitive.smin_caml_floor_retint:
cvt.w.s f0 f0
mfc1 f0 r1
jr r31
min_caml_float_of_int:
test/mandelbrot/math_primitive.smin_caml_float_of_int:
mtc1 r1 f1
cvt.s.w f1 f0
jr r31
