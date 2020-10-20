 /*
 * File: wtfpga.v
 * Project: wtfpga
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Modified WTFpga workshop based off https://github.com/joshajohnson/wtfpga
 */

`default_nettype none

module top(
    input clk_16mhz,

    input [7:0] pmod_a,
    output [7:0] pmod_b

);

    wire ca;
    wire [6:0] seg;

    // PMOD Defines
    wire [7:0] dip_switch;

	// Use this for normal PMOD pinout
	assign dip_switch = {pmod_a[0], pmod_a[1], pmod_a[2], pmod_a[3], pmod_a[4], pmod_a[5], pmod_a[6], pmod_a[7]};
	assign pmod_b[7] = ca;
	assign {pmod_b[6], pmod_b[5], pmod_b[4], pmod_b[3], pmod_b[2], pmod_b[1], pmod_b[0]} = seg;

	// Use below for flipped connector on horizontal breakout
	// assign dip_switch = {pmod_a[3], pmod_a[2], pmod_a[1], pmod_a[0], pmod_a[7], pmod_a[6], pmod_a[5], pmod_a[4]};
    // assign pmod_b[4] = ca;
	// assign {pmod_b[5], pmod_b[6], pmod_b[7], pmod_b[0], pmod_b[1], pmod_b[2], pmod_b[3]} = seg;

    wire [6:0] disp0, disp1;
    wire displayClock;

	nibble_to_seven_seg nibble0(
		.nibblein(dip_switch[3:0]),
		.segout(disp0)
	);	 
	
	nibble_to_seven_seg nibble1(
		.nibblein(dip_switch[7:4]),
		.segout(disp1)
	);	
	 
	clkdiv displayClockGen(
		.clk(clk_16mhz),
		.clkout(displayClock)
	);

	seven_seg_mux display(
		.clk(displayClock),
		.disp0(disp0),
		.disp1(disp1),
		.segout(seg),
		.disp_sel(ca)
	);

endmodule