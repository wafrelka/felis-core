`timescale 1ns / 100ps

module ProgramLoader(

	input logic clk,
	input logic reset,
	output logic completed,

	output logic uart_out_valid,
	input logic[7:0] uart_out_data,
	input logic uart_out_ready,

	output logic[31:0] inst_mem_in_addr,
	output logic[31:0] inst_mem_in_data,
	output logic inst_mem_in_valid,
	input logic inst_mem_in_ready

	);

	enum integer {INIT, READING_SIZE, STORING_SIZE,
		READING_PROG, STORING_PROG, COMPLETED} state;

	logic[31:0] prog_counter;
	logic[31:0] prog_size;
	logic[3:0] read_size;
	logic[31:0] buffer;

	always_comb begin

		completed = (state == COMPLETED);

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			prog_counter <= 0;
			prog_size <= 0;
			read_size <= 0;
			uart_out_valid <= 0;
			inst_mem_in_valid <= 0;
			state <= INIT;

		end else begin

			if(state == INIT) begin

				state <= READING_SIZE;
				uart_out_valid <= 1;

			end else if(state == READING_SIZE || state == READING_PROG) begin

				if(uart_out_ready) begin

					case(read_size)
						0: buffer[ 7: 0] <= uart_out_data;
						1: buffer[15: 8] <= uart_out_data;
						2: buffer[23:16] <= uart_out_data;
						3: buffer[31:24] <= uart_out_data;
					endcase

					if(read_size == 3) begin

						read_size <= 0;
						uart_out_valid <= 0;
						state <= (state == READING_SIZE ? STORING_SIZE : STORING_PROG);

					end else begin

						read_size <= read_size + 1;

					end

				end

			end else if(state == STORING_SIZE) begin

				prog_size <= buffer;
				state <= READING_PROG;
				uart_out_valid <= 1;

			end else if(state == STORING_PROG) begin

				if(!inst_mem_in_valid) begin

					inst_mem_in_valid <= 1;
					inst_mem_in_addr <= prog_counter;
					inst_mem_in_data <= buffer;

				end else if(inst_mem_in_ready) begin

					inst_mem_in_valid <= 0;
					prog_counter <= prog_counter + 4;

					if(prog_counter + 4 < prog_size) begin
						state <= READING_PROG;
						uart_out_valid <= 1;
					end else begin
						state <= COMPLETED;
					end

				end

			end

		end

	end

endmodule
