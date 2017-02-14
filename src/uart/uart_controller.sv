`timescale 1ns / 100ps

module UartController #(

	parameter integer BUFFER_BIT_WIDTH = 10

	) (

	input logic clk,
	input logic reset,
	output logic lost,

	output logic recv_reset,
	input logic[7:0] recv_data,
	input logic recv_ok,

	output logic trans_reset,
	output logic[7:0] trans_data,
	output logic trans_ok,
	input logic trans_busy,

	input logic[7:0] uart_in_data,
	input logic uart_in_valid,
	output logic uart_in_ready,
	input logic uart_out_valid,
	output logic[7:0] uart_out_data,
	output logic uart_out_ready,

	output logic[BUFFER_BIT_WIDTH-1:0] in_buffer_length,
	output logic[BUFFER_BIT_WIDTH-1:0] out_buffer_length

	);

	logic[7:0] recv_buffer [2 ** BUFFER_BIT_WIDTH];
	logic[(BUFFER_BIT_WIDTH-1) : 0] recv_head, recv_tail;
	logic[7:0] trans_buffer [2 ** BUFFER_BIT_WIDTH];
	logic[(BUFFER_BIT_WIDTH-1) : 0] trans_head, trans_tail;

	logic recv_empty, recv_full;
	logic trans_empty, trans_full;

	always_comb begin
		recv_reset = reset;
		trans_reset = reset;
		recv_empty = (recv_head == recv_tail);
		recv_full = (recv_tail + 1 == recv_head);
		trans_empty = (trans_head == trans_tail);
		trans_full = (trans_tail + 1 == trans_head);
		in_buffer_length = (recv_tail - recv_head);
		out_buffer_length = (trans_tail - trans_head);
	end

	always_ff @(posedge clk) begin

		if(reset) begin

			recv_head <= 0;
			recv_tail <= 0;
			lost <= 0;
			uart_out_ready <= 0;

		end else begin

			if(recv_ok) begin

				if(!recv_full) begin
					recv_buffer[recv_tail] <= recv_data;
					recv_tail <= recv_tail + 1;
				end else begin
					lost <= 1;
				end

			end

			if(uart_out_valid && !uart_out_ready && !recv_empty) begin
				uart_out_data <= recv_buffer[recv_head];
				recv_head <= recv_head + 1;
				uart_out_ready <= 1;
			end else begin
				uart_out_ready <= 0;
			end

		end

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			trans_head <= 0;
			trans_tail <= 0;
			trans_ok <= 0;
			uart_in_ready <= 0;

		end else begin

			if(!trans_busy && !trans_empty) begin
				trans_data <= trans_buffer[trans_head];
				trans_head <= trans_head + 1;
				trans_ok <= 1;
			end else begin
				trans_ok <= 0;
			end

			if(uart_in_valid && !uart_in_ready && !trans_full) begin
				trans_buffer[trans_tail] <= uart_in_data;
				trans_tail <= trans_tail + 1;
				uart_in_ready <= 1;
			end else begin
				uart_in_ready <= 0;
			end

		end

	end

endmodule
