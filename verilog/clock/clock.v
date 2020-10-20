/*
 * File: clock.v
 * Project: clock
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Gateware for the clock / test fixture board
 */

`default_nettype none

module top(
    input clk_16mhz,

    output [7:0] pmod_a,
    output [7:0] pmod_b,
    output [7:0] pmod_c,
    output [7:0] pmod_d,
    output [7:0] pmod_e,
    output [7:0] pmod_f,
    output [7:0] pmod_g,
    inout [7:0] pmod_h // pmod_h[7] is button input
);

	// Ref Clk
	reg [24:0] ctr = 0;
    always @(posedge clk_16mhz) begin
        ctr <= ctr + 1;
    end

	// Clock Control
	reg [6:0] second = 1;
	reg [6:0] minute = 0;
	reg [4:0] hour = 0;

	// Slow mode when button pressed
	reg clock = 0;
	always @(posedge clk_16mhz) begin
		if (pmod_h[7] == 1) begin
			clock <= ctr[16];
		end
		else begin
			clock <= ctr[23];
		end
	end

	always @(posedge clock) begin
		// Second Counter
		if (second < 59)
			second <= second + 1;
		else
			second <= 0;
		// Minute Counter
		if (second == 59 && minute < 59)
			minute <= minute + 1;
		if (second == 59 && minute >= 59)
			minute <= 0;
		// Hour Counter
		if (second == 59 && minute == 59 && hour < 11)
			hour <= hour + 1;
		if (second == 59 && minute == 59 && hour >= 11)
			hour <= 0;
	end

	// Intensity control
	reg [7:0] int_r = 0;
	reg [7:0] int_g = 0;
	reg [7:0] int_b = 0;

	// Round robin counter for which led / clock hand to enable
    reg [1:0] hand_control = 0;
    always @(posedge ctr[10]) begin
        if (hand_control < 2) 
            hand_control <= hand_control + 1;
        else
            hand_control <= 0;
    end

	// Light up correct clock hand and colour at the same time
	always @(posedge clk_16mhz) begin
        case (hand_control)

        2'b00: begin // Second
            leds <= 1 << second;
			int_r <= 8'd140;
			int_g <= 8'd012;
			int_b <= 8'd255;
        end

        2'b01: begin // Minute
            leds <= 1 << minute;
			int_r <= 8'd255;
			int_g <= 8'd064;
			int_b <= 8'd025;
        end

        2'b10: begin // Hour
           	leds <= 1 << hour * 5;
			int_r <= 8'd200;
			int_g <= 8'd200;
			int_b <= 8'd000;
        end

		default: begin
			leds <= 60'd0;
			int_r <= 8'd0;
			int_g <= 8'd0;
			int_b <= 8'd0;
		end
        endcase
    end

	// Multiplexed led driver
	rgb_control rgb_clk
	(
		.clk 	(clk_16mhz),
		.en_r 	(1'b1),
		.en_g 	(1'b1),
		.en_b 	(1'b1),
		.int_r  (int_r),
		.int_g  (int_g),
		.int_b  (int_b),
		.out_r 	(pmod_h [3]),
		.out_g 	(pmod_h [6]),
		.out_b 	(pmod_h [2])
	);

	// Physical position to clock number mapping
	reg [59:0] leds;
	assign pmod_d [2] = leds [0];
	assign pmod_d [6] = leds [1];
	assign pmod_d [3] = leds [2];
	assign pmod_d [7] = leds [3];
	assign pmod_c [7] = leds [4];
	assign pmod_c [3] = leds [5];
	assign pmod_c [6] = leds [6];
	assign pmod_c [2] = leds [7];
	assign pmod_c [5] = leds [8];
	assign pmod_c [1] = leds [9];
	assign pmod_c [4] = leds [10];
	assign pmod_c [0] = leds [11];
	assign pmod_b [7] = leds [12];
	assign pmod_b [3] = leds [13];
	assign pmod_b [6] = leds [14];
	assign pmod_b [2] = leds [15];
	assign pmod_b [5] = leds [16];
	assign pmod_b [1] = leds [17];
	assign pmod_b [4] = leds [18];
	assign pmod_b [0] = leds [19];
	assign pmod_a [7] = leds [20];
	assign pmod_a [3] = leds [21];
	assign pmod_a [6] = leds [22];
	assign pmod_a [2] = leds [23];
	assign pmod_a [5] = leds [24];
	assign pmod_a [1] = leds [25];
	assign pmod_a [4] = leds [26];
	assign pmod_a [0] = leds [27];
	assign pmod_h [5] = leds [28];
	assign pmod_h [1] = leds [29];
	assign pmod_h [4] = leds [30];
	assign pmod_h [0] = leds [31];
	assign pmod_g [0] = leds [32];
	assign pmod_g [4] = leds [33];
	assign pmod_g [1] = leds [34];
	assign pmod_g [5] = leds [35];
	assign pmod_g [2] = leds [36];
	assign pmod_g [6] = leds [37];
	assign pmod_g [3] = leds [38];
	assign pmod_g [7] = leds [39];
	assign pmod_f [0] = leds [40];
	assign pmod_f [4] = leds [41];
	assign pmod_f [1] = leds [42];
	assign pmod_f [5] = leds [43];
	assign pmod_f [2] = leds [44];
	assign pmod_f [6] = leds [45];
	assign pmod_f [3] = leds [46];
	assign pmod_f [7] = leds [47];
	assign pmod_e [0] = leds [48];
	assign pmod_e [4] = leds [49];
	assign pmod_e [1] = leds [50];
	assign pmod_e [5] = leds [51];
	assign pmod_e [2] = leds [52];
	assign pmod_e [6] = leds [53];
	assign pmod_e [3] = leds [54];
	assign pmod_e [7] = leds [55];
	assign pmod_d [0] = leds [56];
	assign pmod_d [4] = leds [57];
	assign pmod_d [1] = leds [58];
	assign pmod_d [5] = leds [59];

endmodule