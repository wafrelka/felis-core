`timescale 1ns / 100ps

module FpuAluElemTester();

	logic clk = 0;
	logic reset, completed;

	logic[5:0] inst_num;
	logic[31:0] fs, ft;
	logic[31:0] out;

	FpuAluExecElement fpu_alu_elem(.*);

	always #10 clk <= !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	task check(
		input logic[5:0] arg_inst_num,
		input logic[31:0] arg_fs,
		input logic[31:0] arg_ft,
		input logic[31:0] expected_out
		);
		inst_num = arg_inst_num;
		fs = arg_fs;
		ft = arg_ft;
		reset = 1;
		stop(2);
		reset = 0;
		@(posedge completed);
		assert(out == expected_out);
	endtask

	initial begin

		// check(inst, fs, ft, expected)

		// ABS.S
		check(54, 32'hffffffff, 0, 32'h7fffffff);
		check(54, 32'h7fffffff, 0, 32'h7fffffff);

		// NEG.S
		check(55, 32'h7fffffff, 0, 32'hffffffff);
		check(55, 32'hffffffff, 0, 32'h7fffffff);

		// ADD.S
		check(56, 32'h4048f5c3, 32'h411ffbe7, 32'h41523958); //  3.14 +  9.999
		check(56, 32'h4048f5c3, 32'hc11ffbe7, 32'hc0db7cec); //  3.14 + -9.999
		check(56, 32'hc048f5c3, 32'h411ffbe7, 32'h40db7cec); // -3.14 +  9.999
		check(56, 32'hc048f5c3, 32'hc11ffbe7, 32'hc1523958); // -3.14 + -9.999

		// SUB.S
		check(57, 32'h4048f5c3, 32'h411ffbe7, 32'hc0db7cec); //  3.14 -  9.999
		check(57, 32'h4048f5c3, 32'hc11ffbe7, 32'h41523958); //  3.14 - -9.999
		check(57, 32'hc048f5c3, 32'h411ffbe7, 32'hc1523958); // -3.14 -  9.999
		check(57, 32'hc048f5c3, 32'hc11ffbe7, 32'h40db7cec); // -3.14 - -9.999

		// MUL.S
		check(58, 32'h4048f5c3, 32'h411ffbe7, 32'h41fb2cc5); //  3.14 *  9.999
		check(58, 32'h4048f5c3, 32'hc11ffbe7, 32'hc1fb2cc5); //  3.14 * -9.999
		check(58, 32'hc048f5c3, 32'h411ffbe7, 32'hc1fb2cc5); // -3.14 *  9.999
		check(58, 32'hc048f5c3, 32'hc11ffbe7, 32'h41fb2cc5); // -3.14 * -9.999

		// DIV.S
		check(59, 32'h4048f5c3, 32'h411ffbe7, 32'h3ea0c8ba); //  3.14 /  9.999
		check(59, 32'h4048f5c3, 32'hc11ffbe7, 32'hbea0c8ba); //  3.14 / -9.999
		check(59, 32'hc048f5c3, 32'h411ffbe7, 32'hbea0c8ba); // -3.14 /  9.999
		check(59, 32'hc048f5c3, 32'hc11ffbe7, 32'h3ea0c8ba); // -3.14 / -9.999

		// CVT.S.W
		check(60, 1234567, 0, 32'h4996b438);
		check(60, 0-98765432, 0, 32'hccbc614f);
		check(60, 1234567, 0, 32'h4996b438);
		check(60, 0-98765432, 0, 32'hccbc614f);

		// TODO: CVT.W.S

		// MOV.S
		check(62, 32'hf468fa99, 1, 32'hf468fa99);

		// TODO: SQRT.S
		check(63, 32'h4b3c614e, 1, 32'h455b9a44); // sqrt(12345678.0)

		stop(2);

		$finish();

	end

endmodule
