 /*
 * File: dfu_reset.v
 * Project: common
 * File Created: 2020-10-23
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Enter dfu by pressing button three times whilst connected
 */

 /*
 * Example Instantiation
 * dfu_reset #(
 *     .L(24)
 * ) dfu_watcher (
 *     .clk(clk_16mhz),
 *     .nbtn(btn_usr),
 *     .programn(programn)
 * );
 */

`default_nettype none

module dfu_reset #(
    parameter integer L = 24    // Bigger L = more time to press button
)(
    input wire  clk,
    input wire  nbtn,           // active low (default uBtn on ECP5-Mini)
    output wire programn        // active low
);

    // Debounce button
    wire db, rise, fall;
    debounce #(
		.D(16), 
		.L(8)   
    ) rst_db  (
		.clk(clk),
		.in(~nbtn),
		.db(db),
		.rise(rise),
		.fall(fall)
	);

    reg rst = 0;
    assign programn = ~rst;
    
	reg [L:0] ctr = 0; 
    reg [2:0] pressed = 0;  // Number of times button is pressed

    // Counting / reset logic
    always @(posedge clk) begin

        if (ctr == (2 ** L) - 2) begin  // Timeout
            pressed <= 0;
            ctr <= ctr + 1;
        end else if (pressed == 3)      // Reset
            rst <= 1;
        else if (pressed == 0 && rise) begin    // Reset clock on first press
            ctr <= 0;
            pressed <= pressed + 1;
        end else if (rise)              // Count up presses
            pressed <= pressed + 1;
        else                            // Keep track of time
            ctr <= ctr + 1;
    end

endmodule