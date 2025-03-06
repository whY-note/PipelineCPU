`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 20:01:16
// Design Name: 
// Module Name: Forwarding_Unit_tb
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


module Forwarding_Unit_tb( );
    //input 
    reg MEM_RegWre,WB_RegWre;
    reg [4:0] EX_rs,EX_rt,MEM_WriteReg,WB_WriteReg;
    //output
    wire [1:0] ForwardA,ForwardB;
    
    //例化
    Forwarding_Unit forwarding_unit(
        .MEM_RegWre(MEM_RegWre),
        .WB_RegWre(WB_RegWre),
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .MEM_WriteReg(MEM_WriteReg),
        .WB_WriteReg(WB_WriteReg),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    
    initial begin
    //Test1:EX_rs==MEM_WriteReg
        MEM_RegWre=1;
        WB_RegWre=1;
        EX_rs=5'd3;
        EX_rt=5'd4;
        MEM_WriteReg=5'd3;
        WB_WriteReg=5'd1;
        #50;
        
    //Test2:EX_rt==MEM_WriteReg
        MEM_WriteReg=5'd4;
        #50;
        
    //Test3:EX_rs==WB_WriteReg
        MEM_WriteReg=5'd20;
        WB_WriteReg=5'd3;
        #50;
        
    //Test4:EX_rt==WB_WriteReg
        WB_WriteReg=5'd4;
        #50;
        
    //Test5:EX_rs==MEM_WriteReg==WB_WriteReg
        MEM_WriteReg=5'd3;
        WB_WriteReg=5'd3;
        #50;
        
    //Test6:EX_rt==MEM_WriteReg==WB_WriteReg  
        MEM_WriteReg=5'd4;
        WB_WriteReg=5'd4;
        #50;
        
    //Test7:EX_rs==EX_rt==MEM_WriteReg==WB_WriteReg
    // 此时要从MEM转发到EX的 rs以及rt
        EX_rs=5'd1;
        EX_rt=5'd1;
        MEM_WriteReg=5'd1;
        WB_WriteReg=5'd1;
        #50;
        
    //Test8:都不相等
        EX_rs=5'd1;
        EX_rt=5'd2;
        MEM_WriteReg=5'd10;
        WB_WriteReg=5'd20;
        #50;
        
        $stop;
    end
    
endmodule
