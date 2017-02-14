`timescale 1ns / 100ps

module Board(
	input logic UART_RX,
	output logic UART_TX,
	input logic CLK_P,
	input logic CLK_N,
	input logic RESET_BTN
	);

	logic clk;

	// clock: 100 [MHz]
	// baudrate: 115200 [baud]
	// uart interval: 868 [Hz/baud]

	Chip #(10, 433, 867, 868, 14, 22) chip(
		.clk(clk), .chip_reset(RESET_BTN), .uart_rx(UART_RX), .uart_tx(UART_TX));

	ClockIP clock(.clk_in1_p(CLK_P), .clk_in1_n(CLK_N), .clk_out1(clk));

endmodule
