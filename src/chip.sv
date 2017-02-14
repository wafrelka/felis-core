`timescale 1ns / 100ps

module Chip #(

	parameter integer UART_BUFFER_BIT_WIDTH,
	parameter logic[31:0] UART_RECHECK_INTERVAL,
	parameter logic[31:0] UART_RECV_INTERVAL,
	parameter logic[31:0] UART_TRANS_INTERVAL,
	parameter logic[31:0] INST_MEM_BIT_WIDTH,
	parameter logic[31:0] MAIN_MEM_BIT_WIDTH

	) (

	input logic clk,
	input logic chip_reset,
	input logic uart_rx,
	output logic uart_tx,
	output logic debug_signals [8]

	);

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

	logic uart_out_valid_pl;
	logic uart_out_valid_core;

	logic core_reset;
	logic inst_mem_reset;
	logic main_mem_reset;
	logic uart_reset;
	logic pl_reset;
	logic pl_completed;

	logic[4:0] reset_count = INIT_RESET_COUNT;
	logic uart_lost;
	logic core_halted;
	logic uart_busy;
	logic[9:0] uart_buffer_length;

	localparam logic[4:0] INIT_RESET_COUNT = 15;

	Core core(.reset(core_reset), .uart_out_valid(uart_out_valid_core),
		.halted(core_halted), .*);
	Uart #(
		UART_BUFFER_BIT_WIDTH,
		UART_RECHECK_INTERVAL,
		UART_RECV_INTERVAL,
		UART_TRANS_INTERVAL
	) uart(.reset(uart_reset), .lost(uart_lost),
		.busy(uart_busy), .in_buffer_length(uart_buffer_length), .*);

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

	LargeMemory main_mem(
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

	ProgramLoader prog_loader(
		.clk(clk),
		.reset(pl_reset),
		.completed(pl_completed),
		.uart_out_valid(uart_out_valid_pl),
		.uart_out_data(uart_out_data),
		.uart_out_ready(uart_out_ready),
		.inst_mem_in_addr(inst_mem_in_addr),
		.inst_mem_in_data(inst_mem_in_data),
		.inst_mem_in_valid(inst_mem_in_valid),
		.inst_mem_in_ready(inst_mem_in_ready)
	);

	always_comb begin

		uart_out_valid = (uart_out_valid_pl || uart_out_valid_core);

		core_reset = !pl_completed;
		inst_mem_reset = pl_reset;
		main_mem_reset = !pl_completed;
		uart_reset = pl_reset;

	end

	always_comb begin

		debug_signals[0] = pl_reset;
		debug_signals[1] = pl_completed;
		debug_signals[2] = 0;
		debug_signals[3] = uart_out_valid;
		debug_signals[4] = inst_mem_in_valid;
		debug_signals[5] = uart_lost;
		debug_signals[6] = (uart_buffer_length > 0);

	end

	always_comb begin

		pl_reset = (reset_count > 0);

	end

	always_ff @(posedge clk) begin

		if(chip_reset) begin
			reset_count <= INIT_RESET_COUNT;
		end else if(reset_count > 0) begin
			reset_count <= reset_count - 1;
			debug_signals[7] <= 0;
		end else if(uart_buffer_length > 0) begin
			debug_signals[7] <= 1;
		end

	end

endmodule
