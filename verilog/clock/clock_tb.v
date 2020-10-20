/*
 * File: clock_tb.v
 * Project: clock
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Test bench for the clock / test fixture board
 */

`timescale 1ns/10ps
`include "clock.v"

module clock_tb();

	reg clk_16mhz;

    reg btn_usr;

    wire led_usr;
    wire led_act;

    wire led_r;
    wire led_g;
    wire led_b;
    wire [7:0] led;

    wire [7:0] pmod_a;
    wire [7:0] pmod_b;
    wire [7:0] pmod_c;
    wire [7:0] pmod_d;
    wire [7:0] pmod_e;
    wire [7:0] pmod_f;
    wire [7:0] pmod_g;
    wire [7:0] pmod_h;

	// Clock
	initial begin
		clk_16mhz = 0;
		// 16 MHz
		forever #(31.25) clk_16mhz = ~clk_16mhz;
	end

	top inst_top
	(
		.clk_16mhz (clk_16mhz),
		.btn_usr (btn_usr),
		.led_usr (led_usr),
		.led_act (led_act),
		.led_r   (led_r),
		.led_g   (led_g),
		.led_b   (led_b),
		.led     (led),
		.pmod_a  (pmod_a),
		.pmod_b  (pmod_b),
		.pmod_c  (pmod_c),
		.pmod_d  (pmod_d),
		.pmod_e  (pmod_e),
		.pmod_f  (pmod_f),
		.pmod_g  (pmod_g),
		.pmod_h  (pmod_h)
	);

	// Dump wave
	initial begin
		$dumpfile("clock_tb.lxt");
		$dumpvars(0,clock_tb);
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