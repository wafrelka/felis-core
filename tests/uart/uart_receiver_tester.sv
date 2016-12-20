`timescale 1ps / 100fs

module UartReceiverTester();

	logic clk = 0;
	logic reset;
	logic uart_rx;
	logic[7:0] data;
	logic ok;
	logic waiting;

	UartReceiver #(4, 8) UartReceiver(.*);

	always #10 clk <= !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	initial begin

		reset = 1;
		uart_rx = 1;
		stop(4);

		reset = 0;
		stop(10);
		assert(waiting == 1 && ok == 0);

		uart_rx = 0;
		stop(1);
		assert(waiting == 0 && ok == 0);
		uart_rx = 1;
		stop(4);
		assert(waiting == 1 && ok == 0);

		uart_rx = 0;
		stop(1);
		assert(waiting == 0 && ok == 0);
		stop(4);
		assert(waiting == 0 && ok == 0);

		stop(3);
		uart_rx = 1; stop(8);
		uart_rx = 0; stop(8);
		uart_rx = 1; stop(8);
		uart_rx = 1; stop(8);
		uart_rx = 0; stop(8);
		uart_rx = 0; stop(8);
		uart_rx = 1; stop(8);
		uart_rx = 1; stop(5);
		assert(waiting == 0 && ok == 1);
		assert(data == 8'b11001101);

		stop(1);
		assert(waiting == 0 && ok == 0);
		stop(2);
		assert(waiting == 0 && ok == 0);
		uart_rx = 1; stop(1);
		assert(waiting == 1 && ok == 0);

		stop(7);
		uart_rx = 0; stop(8);

		uart_rx = 1; stop(8);
		uart_rx = 1; stop(8);
		uart_rx = 1; stop(8);
		uart_rx = 0; stop(8);
		uart_rx = 0; stop(8);
		uart_rx = 0; stop(8);
		uart_rx = 0; stop(8);
		uart_rx = 1; stop(5);
		assert(waiting == 0 && ok == 1);
		assert(data == 8'b10000111);

		stop(3);
		uart_rx = 1; stop(1);
		assert(waiting == 1);

		$finish();

	end

endmodule
