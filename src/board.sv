`timescale 1ns / 100ps

module Board(
	input logic sys_clk,
	input logic uart_rx,
	output logic uart_tx
	);

	logic clk;

	always_comb begin
		clk = sys_clk;
	end

	Chip #(10, 433, 867, 868, 14, 22) chip(.*);

endmodule
