 /*
 * File: nightrider_tb.v
 * Project: nightrider
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Nightrider testbench using the onboard ECP5-Mini LEDs.
 */


`timescale 1ns/10ps
`include "nightrider.v"

module nightrider_tb();

	reg clk_16mhz;

    wire btn_usr;

    wire led_usr;
    wire led_act;

    wire led_r;
    wire led_g;
    wire led_b;
    wire [7:0] led;

	// Clock
	initial begin
		clk_16mhz = 0;
		forever #(31.25) clk_16mhz = ~clk_16mhz; // 16 MHz
	end

	top inst_top
	(
		.clk_16mhz  (clk_16mhz),
		.btn_usr (btn_usr),
		.led_usr (led_usr),
		.led_act (led_act),
		.led_r   (led_r),
		.led_g   (led_g),
		.led_b   (led_b),
		.led     (led)
	);

	// Simulate toggling button
	reg [20:0] btn_count = 0;
	always @ (posedge clk_16mhz) begin
		btn_count <= btn_count + 1;
	end

	assign btn_usr = btn_count[20];

	// Dump wave
	initial begin
		$dumpfile("nightrider_tb.lxt");
		$dumpvars(0,nightrider_tb);
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