`timescale 1ns / 100ps

module Board(
	input logic UART_RX,
	output logic UART_TX,
	input logic CLK_P,
	input logic CLK_N,
	input logic RESET_BTN,
	output logic DEBUG_SIGNALS [8]
	);

	logic clk;
	logic chip_reset;
	logic uart_rx, uart_tx;

	// clock: 150 [MHz]
	// baudrate: 115200 [baud]
	// uart interval: 1302.08333... [Hz/baud]

	always_ff @(posedge clk) begin
		uart_rx <= UART_RX;
		UART_TX <= uart_tx;
		chip_reset <= RESET_BTN;
	end

	Chip #(10, 650, 1301, 1302, 16) chip(.debug_signals(DEBUG_SIGNALS), .*);

	ClockIP clock(.clk_in1_p(CLK_P), .clk_in1_n(CLK_N), .clk_out1(clk));

endmodule
