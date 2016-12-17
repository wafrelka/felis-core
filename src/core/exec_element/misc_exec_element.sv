module MiscExecElement(

	input clk,
	input reset,
	output completed,

	input logic[31:0] pc,
	input logic[5:0] inst_num,
	input logic[15:0] const16,
	input logic[4:0] shift5,
	input logic[25:0] addr26,
	input logic[31:0] rs,
	input logic[31:0] rt,
	input logic[31:0] rd,
	input logic[31:0] fs,
	input logic[31:0] ft,
	input logic[31:0] fd,

	output logic[31:0] out,

	output logic[7:0] uart_in_data,
	output logic uart_in_valid,
	input logic uart_in_ready,
	output logic uart_out_valid,
	input logic[7:0] uart_out_data,
	input logic uart_out_ready,

	);

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;
			uart_in_valid <= 0;
			uart_out_valid <= 0;

		end else if(!completed) begin

			case(inst_num)

				4: begin // NOP

					completed <= 1;

				end

				5: begin // HALT

					out <= 32'hffffffff;

				end

				6: begin // IN

					if(!uart_out_valid) begin
						uart_out_valid <= 1;
					end else if(uart_out_ready) begin
						uart_out_valid <= 0;
						out[31:8] <= rd[31:8];
						out[7:0] <= uart_out_data;
						completed <= 1;
					end

				end

				7: begin // OUT

					if(!uart_in_valid) begin
						uart_in_valid <= 1;
						uart_in_data <= rs[7:0];
					end else if(uart_in_ready) begin
						uart_in_valid <= 0;
						completed <= 1;
					end

				end

				default: completed <= 1;

			endcase

		end

	end

endmodule
