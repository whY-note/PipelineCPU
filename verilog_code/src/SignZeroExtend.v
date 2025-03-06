`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 17:57:31
// Design Name: 
// Module Name: SignZeroExtend
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


module SignZeroExtend(ExtSel,Immediate,Out
    );
    input ExtSel;//1:∑˚∫≈¿©’π£¨0£∫¡„¿©’π
    input wire [15:0] Immediate;
    output wire [31:0] Out;
    
    assign Out[15:0]=Immediate[15:0];
    assign Out[15:0]=Immediate[15:0];
    assign Out[31:16]= ExtSel==1? {16{Immediate[15]}}:16'b0;
    
endmodule
