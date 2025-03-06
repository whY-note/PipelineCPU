`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 21:28:52
// Design Name: 
// Module Name: Adder_BranchPC_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Adder_BranchPC_tb( );
    //input 
    reg [31:0] EX_PCadd4;
    reg [31:0] EX_Immediate32;
    
    //output 
    wire [31:0] EX_BranchPC;
    
    //ภýปฏ
    Adder_BranchPC adder_branchPC(
    .EX_PCadd4(EX_PCadd4),
    .EX_Immediate32(EX_Immediate32),
    .EX_BranchPC(EX_BranchPC)
    );
    
    initial begin
    //Test1:
        EX_PCadd4=32'h32;
        EX_Immediate32=-32'd2;
        #50;
        
    //Test2:
        EX_PCadd4=32'h84;
        EX_Immediate32=-32'd2;
        #50;
        
        $stop;
    end
endmodule
