`timescale 1ps / 100fs

// FIXME

module ProgramTester();

	localparam integer UART_BIT_WIDTH = 16;
	localparam integer FRONT_BIT_WIDTH = 16;
	localparam integer INST_MEM_BIT_WIDTH = 16;
	localparam integer MAIN_MEM_BIT_WIDTH = 26;

	logic clk = 0;

	logic[31:0] inst_mem_in_addr;
	logic[31:0] inst_mem_in_data;
	logic inst_mem_in_valid;
	logic inst_mem_in_ready;
	logic[31:0] inst_mem_out_addr;
	logic inst_mem_out_valid;
	logic[31:0] inst_mem_out_data;
	logic inst_mem_out_ready;

	logic[31:0] main_mem_in_addr;
	logic[31:0] main_mem_in_data;
	logic main_mem_in_valid;
	logic main_mem_in_ready;
	logic[31:0] main_mem_out_addr;
	logic main_mem_out_valid;
	logic[31:0] main_mem_out_data;
	logic main_mem_out_ready;

	logic[7:0] uart_in_data;
	logic uart_in_valid;
	logic uart_in_ready;
	logic uart_out_valid;
	logic[7:0] uart_out_data;
	logic uart_out_ready;

	logic core_reset;
	logic inst_mem_reset;
	logic main_mem_reset;
	logic uart_reset;

	logic load_reset;
	logic load_completed;

	logic uart_lost;
	logic halted;

	logic[7:0] front_in_data;
	logic front_in_valid;
	logic front_in_ready;
	logic front_out_valid;
	logic[7:0] front_out_data;
	logic front_out_ready;
	logic front_reset;
	logic front_lost;
	logic[FRONT_BIT_WIDTH-1:0] front_buf_len;

	integer fd;
	logic[31:0] temp, read_temp;
	logic[31:0] load_mem_count;

	logic uart_rx;
	logic uart_tx;
	logic uart_busy;

	Core core(.reset(core_reset), .*);
	Uart #(UART_BIT_WIDTH, 4, 8, 8) uart(.reset(uart_reset), .lost(uart_lost),
		.in_buffer_length(), .busy(uart_busy), .*);

	Uart #(FRONT_BIT_WIDTH, 4, 8, 8) front(.reset(front_reset), .lost(front_lost),
		.uart_in_data(front_in_data), .uart_in_valid(front_in_valid),
		.uart_in_ready(front_in_ready), .uart_out_valid(front_out_valid),
		.uart_out_data(front_out_data), .uart_out_ready(front_out_ready),
		.in_buffer_length(front_buf_len), .uart_rx(uart_tx), .uart_tx(uart_rx), .busy(), .*);

	Memory #(INST_MEM_BIT_WIDTH) inst_mem(
		.clk(clk),
		.reset(inst_mem_reset),
		.in_addr(inst_mem_in_addr),
		.in_data(inst_mem_in_data),
		.in_valid(inst_mem_in_valid),
		.in_ready(inst_mem_in_ready),
		.out_addr(inst_mem_out_addr),
		.out_valid(inst_mem_out_valid),
		.out_data(inst_mem_out_data),
		.out_ready(inst_mem_out_ready)
	);

	Memory #(MAIN_MEM_BIT_WIDTH) main_mem(
		.clk(clk),
		.reset(main_mem_reset),
		.in_addr(main_mem_in_addr),
		.in_data(main_mem_in_data),
		.in_valid(main_mem_in_valid),
		.in_ready(main_mem_in_ready),
		.out_addr(main_mem_out_addr),
		.out_valid(main_mem_out_valid),
		.out_data(main_mem_out_data),
		.out_ready(main_mem_out_ready)
	);

	always #10 clk = !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	always_comb begin

		inst_mem_reset = load_reset;
		core_reset = !load_completed;
		main_mem_reset = !load_completed;
		uart_reset = !load_completed;
		front_reset = !load_completed;

	end

	initial begin

		front_in_valid = 0;
		front_out_valid = 0;
		inst_mem_in_valid = 0;

		load_reset = 1; load_completed = 0; stop(10);
		load_reset = 0; stop(1);
		load_mem_count = 0;

		fd = 0;
		fd = $fopen("fib9.bin", "rb");

		while(fd != 0 && !$feof(fd)) begin
			void'($fread(read_temp, fd, 0, 32));
			temp[ 7: 0] = read_temp[31:24];
			temp[15: 8] = read_temp[23:16];
			temp[23:16] = read_temp[15: 8];
			temp[31:24] = read_temp[ 7: 0];
			inst_mem_in_addr = load_mem_count;
			inst_mem_in_data = temp;
			inst_mem_in_valid = 1;
			stop(1);
			assert(inst_mem_in_ready == 1);
			inst_mem_in_valid = 0;
			load_mem_count = load_mem_count + 4;
			stop(2);
		end

		$fclose(fd);

		load_completed = 1; stop(1);
		stop(10);

		@(posedge halted);

		while(uart_busy) begin
			stop(1);
		end

		stop(100);

		fd = $fopen("output.bin", "w");

		while(front_buf_len > 0) begin
			front_out_valid = 1;
			stop(1);
			assert(front_out_ready == 1);
			temp[7:0] = front_out_data;
			front_out_valid = 0;
			$fdisplay(fd, "%8b", temp[7:0]);
			$display("%c", temp[7:0]);
			stop(2);
		end

		$fclose(fd);

		$stop();

	end

endmodule
