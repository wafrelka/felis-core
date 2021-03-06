`timescale 1ns / 100ps

module LargeMemory (

	input logic clk,
	input logic reset,

	input logic[31:0] in_addr,
	input logic[31:0] in_data,
	input logic in_valid,
	output logic in_ready,

	input logic[31:0] out_addr,
	input logic out_valid,
	output logic[31:0] out_data,
	output logic out_ready,

	output logic addr_error

	);

	enum integer {OUT_INACTIVE, OUT_SETTING, OUT_WAITING, OUT_READY} out_state;
	enum integer {IN_INACTIVE, IN_READY} in_state;

	localparam BRAM_BIT_WIDTH = 20;
	localparam BRAM_MAX_SIZE = 655360;

	logic bram_en;
	logic bram_write_en;
	logic[BRAM_BIT_WIDTH-1:0] bram_addr;
	logic[31:0] bram_data;
	logic[31:0] bram_output;

	BlockRamIP bram_submod (
		.clka(clk), .ena(bram_en), .wea(bram_write_en),
		.addra(bram_addr), .dina(bram_data), .douta(bram_output)
	);

	always_comb begin

		in_ready = (in_state == IN_READY);
		out_ready = (out_state == OUT_READY);

		if(in_valid)
			bram_addr = in_addr[BRAM_BIT_WIDTH+1:2];
		else
			bram_addr = out_addr[BRAM_BIT_WIDTH+1:2];

		bram_write_en = (in_valid && (in_state == IN_INACTIVE));
		bram_data = in_data;

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			bram_en <= 1;
			in_state <= IN_INACTIVE;
			out_state <= OUT_INACTIVE;
			addr_error <= 0;

		end else begin

			if(in_valid) begin

				if(in_addr[31:2] >= BRAM_MAX_SIZE)
					addr_error <= 1;

				case(in_state)

					IN_INACTIVE: begin
						in_state <= IN_READY;
					end

					default: begin
						in_state <= IN_INACTIVE;
					end

				endcase

			end else begin

				in_state <= IN_INACTIVE;

				if(out_valid) begin

					if(out_addr[31:2] >= BRAM_MAX_SIZE)
						addr_error <= 1;

					case(out_state)

						OUT_INACTIVE: begin
							out_state <= OUT_WAITING;
						end

						OUT_WAITING: begin
							out_state <= OUT_READY;
							out_data <= bram_output;
						end

						default: begin
							out_state <= OUT_INACTIVE;
						end

					endcase

				end else begin

					out_state <= OUT_INACTIVE;

				end

			end

		end

	end

endmodule
