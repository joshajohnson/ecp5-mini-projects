/*
 * File: rgb_control.v
 * Project: common
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Driver for the multiplexed LEDs on the ECP5-Mini.
 */

`default_nettype none

module rgb_control(
    input clk,
    input en_r,
    input en_g,
    input en_b,
    input [7:0] int_r,
    input [7:0] int_g,
    input [7:0] int_b,

    output reg out_r,
    output reg out_g,
    output reg out_b
);

    // Counter to clock things off
    reg [24:0] ctr = 0;
    always @(posedge clk) begin
        ctr <= ctr + 1;
    end

    // Round robin counter for which LED to enable
    reg [2:0] colour_control = 0;
    
    always @(posedge ctr[12]) begin
        if (colour_control < 2) 
            colour_control <= colour_control + 1;
        else
            colour_control = 0;
    end

    // 30 KHz sawtooth
    reg [7:0] intensity = 0;
    always @(posedge ctr[8]) begin
        intensity <= intensity + 1;
    end

    // Only enable output when it's the LEDs turn, enable is high, and PWM is higher than set intensity
    always @(posedge clk) begin
        case (colour_control)

        2'b00: begin
            out_r <= 1 && en_r && (int_r > intensity);
            out_g <= 0;
            out_b <= 0;
        end

        2'b01: begin
            out_r <= 0;
            out_g <= 1 && en_g && (int_g > intensity);
            out_b <= 0;
        end

        2'b10: begin
            out_r <= 0;
            out_g <= 0;
            out_b <= 1 && en_b && (int_b > intensity);
        end
        endcase
    end

endmodule