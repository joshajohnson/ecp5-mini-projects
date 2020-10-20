/*
 * File: seven_segment.v
 * Project: common
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Driver for the 1BitSquared 7 segment PMOD
 */

`default_nettype none

module seven_segment(
	input clk, 
    input [7:0] disp_val,
    output reg disp_sel,
    output reg [6:0] segments
);
    // Split byte into nibble for each display
    wire [7:0] nibblein0, nibblein1;
    assign nibblein0 = disp_val [3:0];
    assign nibblein1 = disp_val [7:4];

    // Clock for switching displays
    reg [15:0] counter = 0;
    always @(posedge clk)
        counter <= counter+1;

    // Mux Displays
    always @(posedge counter[15])
        case (disp_sel)
            1:begin
                segments<=segout1;
                disp_sel <= 0;
                end
            0:begin
                segments<=segout0;
                disp_sel <= 1;
                end
        endcase

    // Nibble to segement pins
    reg [6:0] segout0;
    reg [6:0] segout1;

    always @*
        case (nibblein0)
            4'h0: segout0 = ~7'b0111111;
            4'h1: segout0 = ~7'b0000110;
            4'h2: segout0 = ~7'b1011011;
            4'h3: segout0 = ~7'b1001111;
            4'h4: segout0 = ~7'b1100110;
            4'h5: segout0 = ~7'b1101101;
            4'h6: segout0 = ~7'b1111101;
            4'h7: segout0 = ~7'b0000111;
            4'h8: segout0 = ~7'b1111111;
            4'h9: segout0 = ~7'b1100111;
            4'hA: segout0 = ~7'b1110111;
            4'hB: segout0 = ~7'b1111100;
            4'hC: segout0 = ~7'b0111001;
            4'hD: segout0 = ~7'b1011110;
            4'hE: segout0 = ~7'b1111001;
            4'hF: segout0 = ~7'b1110001;
            // default case happens whenever an undefined input occurs...
            default: segout0 = ~7'b1001001;
        endcase

    always @*
        case (nibblein1)
            4'h0: segout1 = ~7'b0111111;
            4'h1: segout1 = ~7'b0000110;
            4'h2: segout1 = ~7'b1011011;
            4'h3: segout1 = ~7'b1001111;
            4'h4: segout1 = ~7'b1100110;
            4'h5: segout1 = ~7'b1101101;
            4'h6: segout1 = ~7'b1111101;
            4'h7: segout1 = ~7'b0000111;
            4'h8: segout1 = ~7'b1111111;
            4'h9: segout1 = ~7'b1100111;
            4'hA: segout1 = ~7'b1110111;
            4'hB: segout1 = ~7'b1111100;
            4'hC: segout1 = ~7'b0111001;
            4'hD: segout1 = ~7'b1011110;
            4'hE: segout1 = ~7'b1111001;
            4'hF: segout1 = ~7'b1110001;
            // default case happens whenever an undefined input occurs...
            default: segout1 = ~7'b1001001;
        endcase

endmodule