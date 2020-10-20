/*
 * File: usb_serial_tb.v
 * Project: usb_serial
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Test bench for the usb_serial / test fixture board
 */

`timescale 1ns/10ps
`include "usb_serial.v"

module usb_serial_tb();

	reg CLK_16;

    reg BTN_USR;

    wire LED_USR;
    wire LED_ACT;

    wire LED_R;
    wire LED_G;
    wire LED_B;
    wire [7:0] LED;

    wire [7:0] PMOD_A;
    wire [7:0] PMOD_B;
    wire [7:0] PMOD_C;
    wire [7:0] PMOD_D;
    wire [7:0] PMOD_E;
    wire [7:0] PMOD_F;
    wire [7:0] PMOD_G;
    wire [7:0] PMOD_H;

	// Clock
	initial begin
		CLK_16 = 0;
		// 16 MHz
		forever #(31.25) CLK_16 = ~CLK_16;
	end

	top inst_top
	(
		.CLK_16  (CLK_16),
		.BTN_USR (BTN_USR),
		.LED_USR (LED_USR),
		.LED_ACT (LED_ACT),
		.LED_R   (LED_R),
		.LED_G   (LED_G),
		.LED_B   (LED_B),
		.LED     (LED),
		.PMOD_A  (PMOD_A),
		.PMOD_B  (PMOD_B),
		.PMOD_C  (PMOD_C),
		.PMOD_D  (PMOD_D),
		.PMOD_E  (PMOD_E),
		.PMOD_F  (PMOD_F),
		.PMOD_G  (PMOD_G),
		.PMOD_H  (PMOD_H)
	);

	// Dump wave
	initial begin
		$dumpfile("usb_serial_tb.lxt");
		$dumpvars(0,usb_serial_tb);
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