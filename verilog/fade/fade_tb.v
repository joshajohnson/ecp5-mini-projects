 /*
 * File: fade_tb.v
 * Project: fade
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Blinky testbench for the ECP5-Mini
 */

`timescale 1ns/10ps
`include "fade.v"

module fade_tb();

	reg clk_16mhz;

    wire led_usr;


	// Clock
	initial begin
		clk_16mhz = 0;
		forever #(31.25) clk_16mhz = ~clk_16mhz; // 16 MHz
	end

	top inst_top
	(
		.clk_16mhz  (clk_16mhz),
		.led_usr (led_usr)

	);

	// Dump wave
	initial begin
		$dumpfile("fade_tb.lxt");
		$dumpvars(0,fade_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 100;
	localparam SIM_TIME = SIM_TIME_MS * 1000_000; // @ 1 ns / unit
	initial begin
		$display("Simulation Started");
		#(SIM_TIME/10);
		$display("10%");
		#(SIM_TIME/10);
		$display("20%");
		#(SIM_TIME/10);
		$display("30%");
		#(SIM_TIME/10);
		$display("40%");
		#(SIM_TIME/10);
		$display("50%");
		#(SIM_TIME/10);
		$display("60%");
		#(SIM_TIME/10);
		$display("70%");
		#(SIM_TIME/10);
		$display("80%");
		#(SIM_TIME/10);
		$display("90%");
		#(SIM_TIME/10);
		$display("Finished");
		$finish;
	end

endmodule