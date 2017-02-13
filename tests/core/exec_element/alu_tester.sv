`timescale 1ps / 100fs

module AluElemTester();

	logic clk = 0;
	logic reset, completed;

	logic[5:0] inst_num;
	logic[31:0] const16_x;
	logic[4:0] shift5;
	logic[31:0] rs, rt;
	logic[31:0] out;

	logic[31:0] minus_tmp;

	AluExecElement alu_elem(.*);

	always #10 clk <= !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	function logic[31:0] minus(logic[15:0] val16);
		minus_tmp[31:16] = 0;
		minus_tmp[15:0] = val16;
		minus = ~minus_tmp + 1;
	endfunction

	task check(
		input logic[5:0] arg_inst_num,
		input logic[31:0] arg_const16_x,
		input logic[4:0] arg_shift5,
		input logic[31:0] arg_rs,
		input logic[31:0] arg_rt,
		input logic[31:0] expected_out
		);
		inst_num = arg_inst_num;
		const16_x = arg_const16_x;
		shift5 = arg_shift5;
		rs = arg_rs;
		rt = arg_rt;
		reset = 1;
		stop(2);
		reset = 0;
		@(posedge completed);
		assert(out == expected_out);
	endtask

	initial begin

		// check(inst, const16, shift5, rs, rt, expected)

		// ADDI
		check(9, 16'h00ff, 0, 17, 0, (17 + 255));
		check(9, minus(16'h00ff), 0, 17, 0, (17 - 255));

		// SUB
		check(10, 0, 0, 17, 18, 32'hffffffff);
		check(10, 0, 0, 32'ha9876543, 32'h98765432, 32'h11111111);

		// DIV, DIVI
		check(12, 0, 0, 32'h1234567, 32'hdab, 5455);
		check(14, 32'hdab, 0, 32'h1234567, 0, 5455);

		// MULT, MULTI
		check(13, 0, 0, 32'hdab, 32'heae, 13149242);
		check(15, 32'heae, 0, 32'hdab, 0, 13149242);

		// SLL
		check(16, 0,  0, 32'b11000101000011111010001101010111, 0,
			             32'b11000101000011111010001101010111);
		check(16, 0, 15, 32'b11000101000011111010001101010111, 0,
			                            32'b11010001101010111000000000000000);

		// TODO: SRA
		// TODO: SRL

		// AND, OR, XOR, NOR
		check(20, 0, 0, 4'b0011, 4'b0101, 4'b0001); // AND
		check(22, 0, 0, 4'b0011, 4'b0101, 4'b0111); // OR
		check(24, 0, 0, 4'b0011, 4'b0101, 4'b0110); // XOR
		check(26, 0, 0, 4'b0011, 4'b0101, ~(32'b0111)); // NOR

		stop(2);

		$finish();

	end

endmodule
