`timescale 1ns / 100ps

module ProgramLoaderTester();

	logic clk = 0;
	logic reset;
	logic completed;

	logic uart_out_valid;
	logic[7:0] uart_out_data;
	logic uart_out_ready;

	logic[31:0] inst_mem_in_addr;
	logic[31:0] inst_mem_in_data;
	logic inst_mem_in_valid;
	logic inst_mem_in_ready;

	logic[31:0] expected_addr;

	ProgramLoader prog_loader(.*);

	always #10 clk = !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	initial begin

		reset = 1;
		uart_out_ready = 0;
		inst_mem_in_ready = 0;
		stop(2);
		reset = 0;

		stop(1);
		assert(uart_out_valid == 1);

		uart_out_ready = 1;
		uart_out_data = 64; stop(1);
		uart_out_data = 0; stop(1);
		uart_out_data = 0; stop(1);
		uart_out_data = 0; stop(2);

		expected_addr = 0;

		repeat(16) begin

			if(expected_addr != 0)
				assert(uart_out_valid == 1);

			uart_out_data = 8'b01010101; stop(1);
			uart_out_data = 8'b10101010; stop(1);
			uart_out_data = 8'b11000011; stop(1);
			uart_out_data = 8'b11110000; stop(1);

			assert(uart_out_valid == 0);
			assert(inst_mem_in_valid == 0);
			stop(1);

			assert(uart_out_valid == 0);
			assert(inst_mem_in_valid == 1);
			assert(inst_mem_in_data == 32'b11110000110000111010101001010101);
			assert(inst_mem_in_addr == expected_addr);
			assert(completed == 0);

			inst_mem_in_ready = 1;
			expected_addr += 4;
			stop(1);

		end

		assert(uart_out_valid == 0);
		assert(completed == 1);

		$finish();

	end

endmodule
