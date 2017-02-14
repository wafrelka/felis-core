`timescale 1ns / 100ps

module Board(
	input logic sys_clk,
	input logic uart_rx,
	output logic uart_tx
	);

	logic clk;

	Chip chip(.*);

	always_comb begin
		clk = sys_clk;
	end

endmodule
