 /*
 * File: blink.v
 * Project: blink
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Blinky for the ECP5-Mini
 */

`default_nettype none

module top(
    input clk_16mhz,

    input btn_usr,

    output led_usr,
    output led_act,

);

    assign led_usr = ~btn_usr;
    assign led_act = ctr[23];

	reg [24:0] ctr = 0;
    always @(posedge clk_16mhz) begin
        ctr <= ctr + 1;
    end

endmodule