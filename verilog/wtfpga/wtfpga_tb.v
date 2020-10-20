 /*
 * File: wtfpga_tb.v
 * Project: wtfpga
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Modified WTFpga workshop based off https://github.com/joshajohnson/wtfpga
 */

`timescale 1ns/10ps
`include "wtfpga.v"

module wtfpga_tb();

	reg clk_16mhz;

    wire led_usr;
    wire led_act;

    wire led_r;
    wire led_g;
    wire led_b;
    wire [7:0] led;

    reg [7:0] pmod_a;
    wire [7:0] pmod_b;

	// Clock
	initial begin
		clk_16mhz = 0;
		forever #(31.25) clk_16mhz = ~clk_16mhz; // 16 MHz
	end

	top inst_top
	(
		.clk_16mhz (clk_16mhz),
		.led_usr (led_usr),
		.led_act (led_act),
		.led_r   (led_r),
		.led_g   (led_g),
		.led_b   (led_b),
		.led     (led),
		.pmod_a  (pmod_a),
		.pmod_b  (pmod_b)
	);

	
	initial begin 
		#(10_000_000);
		pmod_a = 8'b00000000;
		#(10_000_000);
		pmod_a = 8'b00010000;
		#(10_000_000);
		pmod_a = 8'b00000001;
	end

	// Dump wave
	initial begin
		$dumpfile("wtfpga_tb.lxt");
		$dumpvars(0,wtfpga_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 50;
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