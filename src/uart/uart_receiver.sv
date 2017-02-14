`timescale 1ns / 100ps

module UartReceiver #(

	parameter logic[31:0] RECHECK_INTERVAL = 5000,
	parameter logic[31:0] RECV_INTERVAL = 10000

	) (

	input logic clk,
	input logic reset,

	input logic uart_rx,
	output logic[7:0] data,
	output logic ok,
	output logic waiting

	);

	enum integer {WAITING, DETECTED, RECVING, FINISHED} state;

	logic[2:0] recv_count = 0;
	logic[31:0] clock_count = 0;

	always_comb begin

		waiting = (state == WAITING);

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			state <= WAITING;
			ok <= 0;

		end else begin

			if(state == WAITING) begin

				ok <= 0;
				if(uart_rx == 0) begin
					state <= DETECTED;
					clock_count <= 0;
				end

			end else if(state == DETECTED) begin

				if(clock_count + 1 < RECHECK_INTERVAL) begin
					clock_count <= clock_count + 1;
				end else begin
					state <= ((uart_rx) == 0) ? RECVING : WAITING;
					recv_count <= 0;
					clock_count <= 0;
				end

			end else if(state == RECVING) begin

				if(clock_count + 1 < RECV_INTERVAL) begin

					clock_count <= clock_count + 1;

				end else begin

					data[recv_count] <= uart_rx;
					recv_count <= recv_count + 1;
					clock_count <= 0;

					if(recv_count == 7) begin
						ok <= 1;
						state <= FINISHED;
					end

				end

			end else begin // FINISHED

				ok <= 0;
				clock_count <= clock_count + 1;
				if(clock_count + 1 >= RECV_INTERVAL)
					state <= WAITING;

			end

		end

	end

endmodule
