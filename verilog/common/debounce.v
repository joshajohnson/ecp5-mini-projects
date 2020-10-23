/*
 * File: debounce.v
 * Project: common
 * File Created: 2020-10-23
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Module to debounce signals, utilising a shift register
 */

`default_nettype none

module debounce #(
    parameter integer D = 16,   // Divider for sampling clock
    parameter integer L = 8     // Length for comparison
)(
    input clk,

    input in,                   // Assumes active high

    output db,
    output rise,
    output fall
);

    // States for comparison
    reg [L-1:0] all_one = {L{1'b1}};
    reg [L-1:0] rising = {1'b0, {L-1{1'b1}}};
    reg [L-1:0] falling = {{L-1{1'b1}}, 1'b0};

    // Vars
    reg [1:0] shift_in = 0;

    reg [D-1:0] ctr = 0;
    reg sample = 0;

    reg [L-1:0] shift_comp = 0;

    always @(posedge clk) begin
        // Shift in data prior to sample SR
        shift_in <= {shift_in[0], in};

        // Generate sample clock
        ctr <= ctr + 1;
        if (ctr == (2 ** D) - 2)
            sample <= 1;
        else
            sample <= 0;
            
        // Shift in new sample to compare
        if (sample)
            shift_comp <= {shift_comp[L-2:0], shift_in[1]};
    end

    assign db = shift_comp == all_one   ? 1 : 0;
    // && ctr to keep to one clock period
    assign rise = (shift_comp == rising)  && ctr == 0 ? 1 : 0;
    assign fall = (shift_comp == falling) && ctr == 0 ? 1 : 0;

endmodule