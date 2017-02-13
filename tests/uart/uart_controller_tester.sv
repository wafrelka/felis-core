`timescale 1ps / 100fs

module UartControllerTester();

	logic clk = 0;
	logic reset;

	logic recv_reset;
	logic[7:0] recv_data;
	logic recv_ok;

	logic trans_reset;
	logic trans_data;
	logic trans_ok;
	logic trans_busy;

	logic[7:0] uart_in_data;
	logic uart_in_valid;
	logic uart_in_ready;
	logic uart_out_valid;
	logic[7:0] uart_out_data;
	logic uart_out_ready;

	logic in_buffer_length;

	UartController #(3) uart_controller(.lost(), .*);

	always #10 clk = !clk;

	task stop(input int cycle);
		repeat(cycle)
			@(negedge clk);
	endtask

	initial begin

		reset = 1;
		recv_ok = 0;
		trans_busy = 0;
		uart_in_valid = 0;
		uart_out_valid = 0;

		stop(1);
		assert(trans_reset == 1 && recv_reset == 1);

		stop(4);

		reset = 0;
		stop(1);
		assert(trans_reset == 0 && recv_reset == 0);

		// receiving data

		recv_data = 8'b10110011; recv_ok = 1; stop(1);
		recv_data = 8'b01011111; recv_ok = 1; stop(1);
		recv_data = 8'b01011111; recv_ok = 0; stop(1);
		recv_data = 8'b10101010; recv_ok = 0; stop(1);
		recv_data = 8'b10101010; recv_ok = 1; stop(1);
		recv_ok = 0; stop(1);

		uart_out_valid = 1;
		stop(1); assert(uart_out_ready == 1 && uart_out_data == 8'b10110011);
		stop(1); assert(uart_out_ready == 0);
		stop(1); assert(uart_out_ready == 1 && uart_out_data == 8'b01011111);
		stop(1); assert(uart_out_ready == 0);
		uart_out_valid = 0;
		stop(1); assert(uart_out_ready == 0);

		recv_data = 8'b00001111; recv_ok = 1; stop(1);
		recv_ok = 0; stop(1);

		uart_out_valid = 1;
		stop(1); assert(uart_out_ready == 1 && uart_out_data == 8'b10101010);
		stop(1); assert(uart_out_ready == 0);
		stop(1); assert(uart_out_ready == 1 && uart_out_data == 8'b00001111);
		stop(1); assert(uart_out_ready == 0);
		stop(1); assert(uart_out_ready == 0);
		uart_out_valid = 0;

		// receiving data (overflow)

		repeat(4) begin
			recv_data = 8'b10110011; recv_ok = 1; stop(1);
		end
		repeat(8) begin
			recv_data = 8'b01001100; recv_ok = 1; stop(1);
		end
		recv_ok = 0; stop(1);

		uart_out_valid = 1;
		stop(1); assert(uart_out_ready == 1 && uart_out_data == 8'b10110011);
		repeat(3) begin
			stop(2); assert(uart_out_ready == 1 && uart_out_data == 8'b10110011);
		end
		repeat(3) begin
			stop(2); assert(uart_out_ready == 1 && uart_out_data == 8'b01001100);
		end
		stop(2); assert(uart_out_ready == 0);
		uart_out_valid = 0;

		// transmitting data

		uart_in_data = 8'b01011010; uart_in_valid = 1; stop(1);
		uart_in_data = 8'b01011010; uart_in_valid = 1; stop(1);

		// TODO

		// TODO: transmitting data (overflow)

		// TODO: simultaneous events (recv_ok and trans_ok)

		// TODO: simultaneous events (recv_ok and in_valid)

		// TODO: simultaneous events (trans_ok and out_valid)

		$finish();

	end

endmodule