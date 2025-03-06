`timescale 1ns / 1ps

//Ïû¶¶Ä£¿é

module Keyboard_CLK(
    input Button,
    input BasysCLK,

    output reg CPUCLK
);

    parameter SAMPLE_TIME =	5000;
    
    reg[21:0] count_low;
	reg[21:0] count_high;
	
    reg key_out_reg;
    
    initial
    begin
        CPUCLK=0;
    end


	always@(posedge BasysCLK)
    begin
		count_low <= Button ? 0 : count_low + 1;
		count_high <= Button ? count_high + 1 : 0;
		if(count_high == SAMPLE_TIME)
			key_out_reg <= 1;
		else if(count_low == SAMPLE_TIME)
			key_out_reg <= 0;
	end

    always@(*)
    begin
        CPUCLK =! key_out_reg;
    end

endmodule

