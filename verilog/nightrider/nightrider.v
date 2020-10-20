/*
 * This was copied from the iCE40 nextpnr example. As nextpnr is under the ISC license,
 * this likely also is:
 * 
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

 /*
 * File: nightrider.v
 * Project: nightrider
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Nightrider using the onboard ECP5-Mini LEDs.
 */


 `default_nettype none

module top(
    input clk_16mhz,

    input btn_usr,

    output led_usr,
    output led_act,

    output reg led_r, 
    output reg led_g,
    output reg led_b,
    output [7:0] led

);

    // Status LEDs
    assign led_usr = ~btn_usr;
    assign led_act = ctr[23];

    // Nightrider
	localparam ctr_width = 24;
    localparam ctr_max = 2**ctr_width - 1;
    reg [ctr_width-1:0] ctr = 0;
    reg [9:0] pwm_ctr = 0;
    reg dir = 0;

    always @(posedge clk_16mhz) begin
    ctr <= dir ? ctr - 1'b1 - btn_usr: ctr + 1'b1 + btn_usr;
        if (ctr[ctr_width-1 : ctr_width-3] == 0 && dir == 1)
            dir <= 1'b0;
        else if (ctr[ctr_width-1 : ctr_width-3] == 7 && dir == 0)
            dir <= 1'b1;
        pwm_ctr <= pwm_ctr + 1'b1;
    end

    reg [9:0] brightness [0:7];
    localparam bright_max = 2**10 - 1;
    reg [7:0] led_reg;

    genvar i;
    generate
    for (i = 0; i < 8; i=i+1) begin
       always @ (posedge clk_16mhz) begin
            if (ctr[ctr_width-1 : ctr_width-3] == i)
                brightness[i] <= bright_max;
            else if (ctr[ctr_width-1 : ctr_width-3] == (i - 1))
                brightness[i] <= ctr[ctr_width-4:ctr_width-13];
             else if (ctr[ctr_width-1 : ctr_width-3] == (i + 1))
                 brightness[i] <= bright_max - ctr[ctr_width-4:ctr_width-13];
            else
                brightness[i] <= 0;
            led_reg[i] <= pwm_ctr < brightness[i];
       end
    end
    endgenerate

    assign led = led_reg;

    // Colour Control
    reg [2:0] colour_control = 0;
    parameter RED = 0;
    parameter GREEN = 1;
    parameter BLUE = 2;
    reg [7:0] intensity = 0;
    reg red_en, green_en, blue_en = 0;

    // Brightness control
    always @(posedge ctr[8]) begin
        intensity <= intensity + 1;
        red_en <= 64 > intensity;
        green_en <= 32 > intensity;
        blue_en <= 128 > intensity; 
    end

    // We only want one colour on at the same time due to the multiplexing configuration
    always @(posedge ctr[23]) begin
        if (colour_control < 2) 
            colour_control <= colour_control + 1;
        else
            colour_control = 0;
    end

	always @(posedge clk_16mhz) begin
        case (colour_control)

        RED: begin
            led_r <= 1 && red_en;
            led_g <= 0;
            led_b <= 0;
        end

        GREEN: begin
            led_r <= 0;
            led_g <= 1 && green_en;
            led_b <= 0;
        end

        BLUE: begin
            led_r <= 0;
            led_g <= 0;
            led_b <= 1 && blue_en;
        end
        endcase
    end

endmodule