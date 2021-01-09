 /*
 * File: fade.v
 * Project: fade
 * File Created: 2020-10-17
 * Author: Josh Johnson (josh@joshajohnson.com)
 * Description: Fade for the ECP5-Mini
 */

`default_nettype none

module top(
    input clk_16mhz,

    output led_usr
);

	reg [7:0] duty_cycle = 0;
	reg count_up = 1;
	wire divided_pulse;

	// Fade up / down to "heartbeat" LED
	always @(posedge clk_16mhz) begin
		if (divided_pulse) begin
			if (duty_cycle == 1) begin
				count_up <= 1;
			end else if (duty_cycle == 254) begin
				count_up <= 0;
			end

			if (count_up) begin
				duty_cycle <= duty_cycle + 1;
			end else begin
				duty_cycle <= duty_cycle - 1;
			end
		end
	end

	clk_div_hz #(
		.FREQUENCY(1000)
	) inst_clk_div_hz (
		.clk          (clk_16mhz),
		.rst          (1'b0),
		.enable       (1'b1),
		.dividedClk   (),
		.dividedPulse (divided_pulse)
	);

	pwm #(
		.FREQUENCY(10_000)
	) inst_pwm (
		.clk       (clk_16mhz),
		.rst       (1'b0),
		.enable    (1'b1),
		.dutyCycle (duty_cycle),
		.out       (),
		.nOut      (led_usr)
	);

endmodule