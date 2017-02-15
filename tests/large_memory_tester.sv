`timescale 1ns / 100ps

module LargeMemoryTester();

	localparam logic[31:0] BRAM_MAX_SIZE = 655360;
	localparam logic[31:0] BRAM_MAX_VALID = BRAM_MAX_SIZE * 4 - 1;
	localparam logic[31:0] BRAM_MIN_INVALID = BRAM_MAX_SIZE * 4;

	logic clk = 0;
	logic reset;

	logic[31:0] in_addr, out_addr;
	logic[31:0] in_data, out_data;
	logic in_valid, in_ready, out_valid, out_ready, addr_error;

	LargeMemory large_memory(.*);

	always #10 clk = !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	initial begin

		reset = 1;
		in_valid = 0;
		out_valid = 0;
		stop(2);
		reset = 0;
		stop(2);

		in_addr = 36; in_valid = 1; in_data = 32'hefefefef; stop(1);
		assert(in_ready == 1);
		in_valid = 0; stop(1);
		assert(in_ready == 0);
		in_addr = 40; in_valid = 1; in_data = 32'hc3c3c3c3; stop(1);
		assert(in_ready == 1);
		in_addr = 32; in_valid = 1; in_data = 32'h35353535; stop(1);
		assert(in_ready == 0);
		stop(1);
		assert(in_ready == 1);
		in_valid = 0; stop(1);

		out_addr = 40; out_valid = 1; stop(3);
		assert(out_ready == 1 && out_data == 32'hc3c3c3c3);
		out_valid = 0; stop(1);
		assert(out_ready == 0);
		out_addr = 36; out_valid = 1; stop(3);
		assert(out_ready == 1 && out_data == 32'hefefefef);
		out_addr = 32; out_valid = 1; stop(3);
		assert(out_ready == 0);
		stop(1);
		assert(out_ready == 1 && out_data == 32'h35353535);
		out_valid = 0; stop(1);

		reset = 1; in_valid = 0; out_valid = 0; stop(2);
		reset = 0; stop(2);
		in_data = 0;

		in_addr = BRAM_MIN_INVALID; stop(3);
		assert(addr_error == 0);
		in_addr = BRAM_MAX_VALID; in_valid = 1; stop(1);
		assert(in_ready == 1 && addr_error == 0);
		in_valid = 0; stop(1);
		assert(in_ready == 0 && addr_error == 0);
		in_addr = BRAM_MIN_INVALID; in_valid = 1; stop(1);
		assert(in_ready == 1 && addr_error == 1);

		reset = 1; in_valid = 0; out_valid = 0; stop(2);
		reset = 0; stop(2);

		out_addr = BRAM_MIN_INVALID; stop(3);
		assert(addr_error == 0);
		out_addr = BRAM_MAX_VALID; out_valid = 1; stop(3);
		assert(out_ready == 1 && addr_error == 0);
		out_valid = 0; stop(1);
		assert(out_ready == 0 && addr_error == 0);
		out_addr = BRAM_MIN_INVALID; out_valid = 1; stop(3);
		assert(out_ready == 1 && addr_error == 1);

		$finish();

	end

endmodule
