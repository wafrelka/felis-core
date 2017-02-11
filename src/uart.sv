`timescale 1ps / 100fs

module Uart #(

	parameter integer BUFFER_BIT_WIDTH = 10,
	parameter logic[31:0] RECHECK_INTERVAL = 5048,
	parameter logic[31:0] RECV_INTERVAL = 10096,
	parameter logic[31:0] TRANS_INTERVAL = 10096

	) (

	input logic clk,
	input logic reset,
	input logic uart_rx,
	output logic uart_tx,
	output logic lost,
	output logic busy,

	input logic[7:0] uart_in_data,
	input logic uart_in_valid,
	output logic uart_in_ready,
	input logic uart_out_valid,
	output logic[7:0] uart_out_data,
	output logic uart_out_ready,

	output logic[BUFFER_BIT_WIDTH-1:0] in_buffer_length

	);

	logic recv_reset;
	logic[7:0] recv_data;
	logic recv_ok;

	logic trans_reset;
	logic[7:0] trans_data;
	logic trans_ok;
	logic trans_busy;

	always_comb begin
		busy = trans_busy;
	end

	UartReceiver #(RECHECK_INTERVAL, RECV_INTERVAL) receiver(
		.reset(recv_reset),
		.data(recv_data),
		.ok(recv_ok),
		.waiting(),
	.*);

	UartTransmitter #(TRANS_INTERVAL) transmitter(
		.reset(trans_reset),
		.data(trans_data),
		.ok(trans_ok),
		.busy(trans_busy),
	.*);

	UartController #(BUFFER_BIT_WIDTH) controller(.*);

endmodule
