`timescale 1ps / 100fs

module MemElemTester();

	logic clk = 0;
	logic reset, completed;

	logic[5:0] inst_num;
	logic[31:0] const16_x;
	logic[31:0] rs, rt, rd, fs;
	logic[31:0] out;

	logic[31:0] main_mem_in_addr, main_mem_in_data;
	logic[31:0] main_mem_out_addr;
	logic main_mem_in_valid, main_mem_out_valid;

	MemExecElement mem_elem(.main_mem_in_ready(), .main_mem_out_ready(),
		.main_mem_out_data(), .*);

	always #10 clk <= !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	task check_load(
		input logic[5:0] arg_inst_num,
		input logic[31:0] arg_const16_x,
		input logic[31:0] arg_rs, input logic[31:0] arg_rt,
		input logic[31:0] expected_addr);

		inst_num = arg_inst_num;
		const16_x = arg_const16_x;
		rs = arg_rs; rt = arg_rt;

		reset = 1;
		stop(1);
		reset = 0;
		stop(1);

		assert(main_mem_out_valid);
		assert(main_mem_out_addr == expected_addr);

	endtask

	task check_store(
		input logic[5:0] arg_inst_num,
		input logic[31:0] arg_const16_x,
		input logic[31:0] arg_rs, input logic[31:0] arg_rt,
		input logic[31:0] arg_rd, input logic[31:0] arg_fs,
		input logic[31:0] expected_addr,
		input logic[31:0] expected_data);

		inst_num = arg_inst_num;
		const16_x = arg_const16_x;
		rs = arg_rs; rt = arg_rt; rd = arg_rd; fs = arg_fs;

		reset = 1;
		stop(1);
		reset = 0;
		stop(1);

		assert(main_mem_in_valid);
		assert(main_mem_in_addr == expected_addr);
		assert(main_mem_in_data == expected_data);

	endtask

	logic[31:0] minus_tmp;

	function logic[31:0] minus(logic[15:0] val16);
		minus_tmp[31:16] = 0;
		minus_tmp[15:0] = val16;
		minus = ~minus_tmp + 1;
	endfunction

	initial begin

		// LW, LWO
		check_load(28, 32'h00f0, 32'h00001004, 0, 32'h000010f4);
		check_load(28, minus(16'h00f0), 32'h00001004, 0, 32'h00000f14);
		check_load(29, 0, 32'h00001004, 32'h00f0, 32'h000010f4);
		check_load(29, 0, 32'h00001004, minus(16'h00f0), 32'h00000f14);

		// LWC1, LWOC1
		check_load(48, 32'h00f0, 32'h00001004, 0, 32'h000010f4);
		check_load(48, minus(16'h00f0), 32'h00001004, 0, 32'h00000f14);
		check_load(49, 0, 32'h00001004, 32'h00f0, 32'h000010f4);
		check_load(49, 0, 32'h00001004, minus(16'h00f0), 32'h00000f14);

		// SW, SWO
		check_store(30, 32'h00f0, 12345678, 32'h00001004,
			0, 0, 32'h000010f4, 12345678);
		check_store(30, minus(16'h00f0), 87654321, 32'h00001004,
			0, 0, 32'h00000f14, 87654321);
		check_store(31, 0, 12345678, 32'h00001004,
			32'h00f0, 0, 32'h000010f4, 12345678);
		check_store(31, 0, 87654321, 32'h00001004,
			minus(16'h00f0), 0, 32'h00000f14, 87654321);

		// SWC1, SWOC1
		check_store(50, 32'h00f0, 0, 32'h00001004,
			0, 12345678, 32'h000010f4, 12345678);
		check_store(50, minus(16'h00f0), 0, 32'h00001004,
			0, 87654321, 32'h00000f14, 87654321);
		check_store(51, 0, 0, 32'h00001004,
			32'h00f0, 12345678, 32'h000010f4, 12345678);
		check_store(51, 0, 0, 32'h00001004,
			minus(16'h00f0), 87654321, 32'h00000f14, 87654321);

		$finish();

	end

endmodule
