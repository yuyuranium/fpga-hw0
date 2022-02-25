`timescale 1ns/1ns
`include "SET.v"

module testbench;

//----------Type declaration----------//
    reg clk;
    reg rst;
    reg en;
    reg [23:0] central;
    reg [11:0] radius;
    reg [1:0]mode;
    wire busy;
    wire valid;
    wire [7:0]candidate;
	
//----------Module instance----------//
    SET SET0(clk ,rst, en, central, radius, mode, busy, valid, candidate);
	
//----------Stimulus----------//
    //clock signal, period = 10ns
    always begin
	    #5 clk = ~clk;
	end
	
	initial begin
	    clk = 1'b1;
		$dumpfile("SET.vcd");
		$dumpvars;
	end
	
    initial begin
	    
		rst = 1'b0;
		en = 1'b0;
        central = 24'd0;
        radius = 12'd0;
        mode = 2'd0;
		
		//reset the SET module
		#5 rst = 1'b1;
		#10 rst = 1'b0;
		
		//transmit the first signal about central, radius, and mode
		if(busy == 1'b0) begin
		    #1
		    @(negedge clk) begin
                en = 1'b1;
                central = 24'b0101_0101_0011_0011_0110_0010;
                radius = 12'b0011_0011_0010;
                mode = 2'b00;
			end
		end
		
		#10 
		en = 1'b0;
        central = 24'd0;
        radius = 12'd0;
        mode = 2'd0;
		
		@(negedge valid) begin
		    #1
			//transmit the second signal about central, radius, and mode
			if(busy == 1'b0) begin
		        @(negedge clk) begin
                    en = 1'b1;
                    central = 24'b0101_0101_0011_0011_0110_0010;
                    radius = 12'b0011_0011_0010;
                    mode = 2'b11;
			    end
			end
		end
		
		#10 
		en = 1'b0;
        central = 24'd0;
        radius = 12'd0;
        mode = 2'd0;
		
		@(negedge valid) begin
		    $display("The simulation is done!");
		    $finish;
		end
	end
	
endmodule