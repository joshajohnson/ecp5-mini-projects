/*
 * File: usb_serial.v
 * Project: usb_serial
 * File Created: 2020-10-18
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: A test USB -> serial interface using David Williams "tinyfpga_bx_usbserial" core.
 */

`default_nettype none

module top(
    input clk_16mhz,

    // input btn_usr,

    // output led_usr,
    // output led_act,

    output [7:0] pmod_a,

	inout usb_dm,
	inout usb_dp,
	output reg usb_pu
);

	wire clk_48mhz;
    wire clk_locked;

	pll pll48( .clkin(clk_16mhz), .clkout0(clk_48mhz), .locked( clk_locked ) );

    // Generate reset signal
    reg [5:0] reset_cnt = 0;
    wire reset = ~reset_cnt[5];
    always @(posedge clk_48mhz)
        if ( clk_locked )
            reset_cnt <= reset_cnt + reset;

    // uart pipeline in
    wire [7:0] uart_in_data;
    wire       uart_in_valid;
    wire       uart_in_ready;

    // uart pipeline out
    wire [7:0] uart_out_data;
    wire       uart_out_valid;
    wire       uart_out_ready;

    // usb uart - this instanciates the entire USB device.
    usb_uart uart (
        .clk_48mhz  (clk_48mhz),
        .reset      (reset),

        // pins
        .pin_usb_p( usb_dp ),
        .pin_usb_n( usb_dm ),

        // uart pipeline in
        .uart_in_data( uart_in_data ),
        .uart_in_valid( uart_in_valid ),
        .uart_in_ready( uart_in_ready ),

        // uart pipeline out
        .uart_out_data( uart_in_data ),
        .uart_out_valid( uart_in_valid ),
        .uart_out_ready( uart_in_ready ),
    );

    // Push new data to display only when there is data
    reg [7:0] disp_val = 8'h00;
    always @(posedge clk_48mhz) begin
        if (uart_in_data != 0)
            disp_val <= uart_in_data;
    end

    // Seven segment stuff
    wire ca;
    wire [6:0] seg;

    // Use this for normal PMOD pinout
	assign ca = pmod_a[7];
	assign seg = {pmod_a[6], pmod_a[5], pmod_a[4], pmod_a[3], pmod_a[2], pmod_a[1], pmod_a[0]};

	// Use below for flipped connector on horizontal breakout
    // assign ca = pmod_a[4];
	// assign seg = {pmod_a[5], pmod_a[6], pmod_a[7], pmod_a[0], pmod_a[1], pmod_a[2], pmod_a[3]};

    seven_segment sevenseg(
        .clk(clk_16mhz),
        .disp_val(disp_val),
        .disp_sel(ca),
        .segments(seg)
    );

    // USB Host Detect Pull Up
    // Init low, then pull high after ~250ms
    reg [24:0] ctr = 0;
    always @(posedge clk_16mhz) begin
        if (ctr[24] == 0) begin
            ctr <= ctr + 1;
            usb_pu <= 1'b0;
        end else begin
            usb_pu <= 1'b1;
        end
    end

endmodule