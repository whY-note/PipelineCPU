`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 17:58:21
// Design Name: 
// Module Name: SignZeroExtend_tb
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


module SignZeroExtend_tb( );
    //inputs
    reg signed [15:0] Immediate;
    reg ExtSel;
    
    //outputs
    wire [31:0] Out;
    
    SignZeroExtend uut(
        .Immediate(Immediate),
        .ExtSel(ExtSel),
        .Out(Out)
    );
    
    initial begin
    
        //Test1：测试零扩展
        ExtSel = 0;
        Immediate[15:0] = 15'd9;
        #50;
        
        //Test2：测试符号扩展，最高位=0
        ExtSel = 1;
        Immediate[15:0] = 15'd10;
        #50;
        
        ///Test3：测试符号扩展，最高位=1
        ExtSel = 1;
        Immediate[15:0] = 15'd7;
        Immediate[15] = 1;
        #50;
        
        $stop;
    end

endmodule

