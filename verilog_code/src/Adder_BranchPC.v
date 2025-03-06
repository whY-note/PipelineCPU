`timescale 1ns / 1ps

module Adder_BranchPC(
    input wire [31:0] EX_PCadd4,
    input wire [31:0] EX_Immediate32,
    output wire [31:0] EX_BranchPC
    );
    assign EX_BranchPC=EX_PCadd4+(EX_Immediate32<<2);
    
endmodule
