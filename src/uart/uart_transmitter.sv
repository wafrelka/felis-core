module UartTransmitter #(

	parameter logic[31:0] TRANS_INTERVAL = 10000

	) (

	input logic clk,
	input logic reset,

	output logic uart_tx,
	input logic[7:0] data,
	input logic ok,
	output logic busy

	);

	enum integer {WAITING, TRANSMITTING, HOLDING, FINISHED} state;

	logic[2:0] trans_count = 0;
	logic[31:0] clock_count = 0;
	logic[31:0] buffer;

	always_comb begin

		busy = (state != WAITING);

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			uart_tx <= 1;
			state <= WAITING;

		end else begin

			if(state == WAITING) begin

				if(ok) begin
					uart_tx <= 0;
					state <= TRANSMITTING;
					buffer <= data;
					trans_count <= 0;
					clock_count <= 0;
				end else begin
					uart_tx <= 1;
				end

			end else if(state == TRANSMITTING) begin

				if(clock_count + 1 < TRANS_INTERVAL) begin

					clock_count <= clock_count + 1;

				end else begin

					uart_tx <= buffer[trans_count];
					trans_count <= trans_count + 1;
					clock_count <= 0;

					if(trans_count == 7)
						state <= HOLDING;

				end

			end else if(state == HOLDING) begin

				if(clock_count + 1 < TRANS_INTERVAL) begin
					clock_count <= clock_count + 1;
				end else begin
					uart_tx <= 1;
					state <= FINISHED;
					clock_count <= 0;
				end

			end else begin // FINISHED

			clock_count <= clock_count + 1;
			if(clock_count + 1 >= TRANS_INTERVAL)
				state <= WAITING;

			end

		end

	end

endmodule
