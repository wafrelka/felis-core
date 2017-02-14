`timescale 1ns / 100ps

module UartTransmitterTester();

	logic clk = 0;
	logic reset;
	logic uart_tx;
	logic[7:0] data;
	logic ok;
	logic busy;

	UartTransmitter #(8) uart_transmitter(.*);

	always #10 clk <= !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	initial begin

		reset = 1;
		ok = 0;
		stop(4);
		assert(uart_tx == 1);

		reset = 0;
		stop(10);
		assert(uart_tx == 1 && busy == 0);

		data = 8'b00110101;
		ok = 1;
		stop(1);
		assert(uart_tx == 0 && busy == 1);
		ok = 0;

		stop(8); assert(uart_tx == 1 && busy == 1);
		stop(8); assert(uart_tx == 0 && busy == 1);
		stop(8); assert(uart_tx == 1 && busy == 1);
		stop(8); assert(uart_tx == 0 && busy == 1);
		stop(8); assert(uart_tx == 1 && busy == 1);
		stop(8); assert(uart_tx == 1 && busy == 1);
		stop(8); assert(uart_tx == 0 && busy == 1);
		stop(8); assert(uart_tx == 0 && busy == 1);

		data = 8'b00000000;
		ok = 1;
		stop(8);
		assert(uart_tx == 1 && busy == 1);
		stop(4);
		assert(uart_tx == 1 && busy == 1);

		ok = 0;
		stop(8);
		assert(uart_tx == 1 && busy == 0);

		ok = 1;
		stop(1);
		assert(uart_tx == 0 && busy == 1);
		stop(8);
		assert(uart_tx == 0 && busy == 1);

		$finish();

	end

endmodule
