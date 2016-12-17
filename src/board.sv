module Board(
	input sys_clk,
	input uart_rx,
	output uart_tx,
	);

	logic clk;

	Chip chip(.*);

	always_comb begin
		clk = sys_clk;
	end

endmodule
