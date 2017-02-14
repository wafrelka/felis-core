`timescale 1ns / 100ps

module Board(
	input logic uart_rx,
	output logic uart_tx,
	input logic clk_p,
	input logic clk_n
	);

	logic clk;

	// clock: 100 [MHz]
	// baudrate: 115200 [baud]
	// uart interval: 868 [Hz/baud]

	Chip #(10, 433, 867, 868, 14, 22) chip(.*);
	ClockIP clock(.clk_in1_p(clk_p), .clk_in1_n(clk_n), .clk_out1(clk));

endmodule
