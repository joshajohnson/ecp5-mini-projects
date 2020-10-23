
`timescale 1ns/100ps
`include "debounce.v"

module debounce_tb();

	reg clk_16mhz;

    reg btn = 0;

	wire db, rise, fall;

	debounce #(
		.D(6), 
		.L(8)   
	)	UUT	(
		.clk(clk_16mhz),
		.in(btn),
		.db(db),
		.rise(rise),
		.fall(fall)
	);

	// Clock
	initial begin
		clk_16mhz = 0;
		forever #(31.25) clk_16mhz = ~clk_16mhz;
	end

	// Button
	initial begin
		btn = 0;
		#(10311);
		btn = 1;
		#(500000);
		btn = 0;
		#(1000000);
		btn = 1;
		#(201232);
		btn = 0;
		#(10022);
		btn = 1;
	end

	// Dump wave
	initial begin
		$dumpfile("debounce_tb.lxt");
		$dumpvars(0,debounce_tb);
	end
	
	// Count in 10% increments and finish sim when time is up
	localparam SIM_TIME_MS = 100;
	localparam SIM_TIME = SIM_TIME_MS * 1000_000; // @ 1 ns / unit
	initial begin
		$display("Simulation Started");
		#(SIM_TIME/10);
		$display("10%");
		#(SIM_TIME/10);
		$display("20%");
		#(SIM_TIME/10);
		$display("30%");
		#(SIM_TIME/10);
		$display("40%");
		#(SIM_TIME/10);
		$display("50%");
		#(SIM_TIME/10);
		$display("60%");
		#(SIM_TIME/10);
		$display("70%");
		#(SIM_TIME/10);
		$display("80%");
		#(SIM_TIME/10);
		$display("90%");
		#(SIM_TIME/10);
		$display("Finished");
		$finish;
	end

endmodule