/*
 * File: sr_74595.v
 * Project: sr_74595
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Driver for Pim de Groot's 74595 PMOD https://github.com/pimdegroot/74595displaykit, based off his iCEBreaker example.
 */

`default_nettype none

module top(
    input clk_16mhz,

    output [7:0] pmod_a

);

    // sr_74595 wires and registers
    reg [24:0] counter = 0;
    always @(posedge clk_16mhz) begin
        counter <= counter + 1;
    end

    reg sr_oe = 0;
    reg sr_lat = 0;
    reg sr_ser = 0;

    reg [3:0] line = 0;
    reg [1:0] line_counter = 0;
    reg [7:0] line_buffer = 0;
    reg [3:0] col_counter = 0;
    reg commit_row = 0;

    reg [7:0] frame_buffer [3:0];

    reg [7:0] lfsr = 1;
    reg update = 0;

    // Signals <-> PMOD
    // Use below for standard PMOD
    assign pmod_a[3:0] = line[3:0];
    assign pmod_a[4] = sr_oe;
    assign pmod_a[5] = sr_lat;
    assign pmod_a[6] = counter[1];
    assign pmod_a[7] = sr_ser;

    // Use below for flipped connector on horizontal breakout
    // assign pmod_a[3] = line[0];
    // assign pmod_a[2] = line[1];
    // assign pmod_a[1] = line[2];
    // assign pmod_a[0] = line[3];

    // assign pmod_a[7] = sr_oe;
    // assign pmod_a[6] = sr_lat;
    // assign pmod_a[5] = counter[1];
    // assign pmod_a[4] = sr_ser;

    // Time to display all the things!
    always @(posedge counter[1]) begin
        
        case (line_counter)
            2'b00: begin
                line = 4'b0001;
            end
            2'b01: begin
                line = 4'b0010;
            end
            2'b10: begin
                line = 4'b0100;
            end
            2'b11: begin
                line = 4'b1000;
            end
        endcase

        if (col_counter == 0 && commit_row == 0) begin
            sr_lat <= 1;
            sr_oe <= 1;
            line_counter <= line_counter + 1;
            commit_row <= 1;
            line_buffer <= frame_buffer[line_counter + 2];
        end else begin
            sr_lat <= 0;
            sr_oe <= 0;
            commit_row <= 0;
            sr_ser <= line_buffer[col_counter];
            col_counter <= col_counter + 1;
        end

        if (counter[20] == 1 && update == 0) begin
            if (col_counter == 0 && line_counter == 0) begin
                update <= 1;
                lfsr <= {lfsr[6:0],~(lfsr[7]^lfsr[2])};

                frame_buffer[3] <= frame_buffer[2];
                frame_buffer[2] <= frame_buffer[1];
                frame_buffer[1] <= frame_buffer[0];
                frame_buffer[0] <= lfsr;

            end
        end else if (counter[20] == 0) begin 
                update <= 0;
            end
    end

endmodule