`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 17:02:47
// Design Name: 
// Module Name: RegDst_Mux_tb
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


module RegDst_Mux_tb( );
    //input
    reg [1:0] RegDst;
    reg [4:0] rt,rd;
    
    //output
    wire [4:0] WriteReg;
    
    //ภýปฏ
    RegDst_Mux regdst_mux(
    .RegDst(RegDst),
    .rt(rt),
    .rd(rd),
    .WriteReg(WriteReg)
    );
    
    initial begin
        rt=5'd1;
        rd=5'd2;
        
        RegDst=2'b00;
        #50;
        
        rt=5'd1;
        rd=5'd2;
        RegDst=2'b01;
        #50;
        
        rt=5'd1;
        rd=5'd2;
        RegDst=2'b10;
        #50;
        
    $stop;
    end

endmodule
