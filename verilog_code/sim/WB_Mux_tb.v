`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 17:25:21
// Design Name: 
// Module Name: WB_Mux_tb
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


module WB_Mux_tb( );
    
    //input
    reg [1:0] DBDataSrc;
    
    reg[31:0] DataFromALU,DataFromMem,WB_PCadd4;
    
    //output
    wire[31:0] WriteData;
    
     WB_Mux wb_mux(
     .DBDataSrc(DBDataSrc),
     .DataFromALU(DataFromALU),
     .DataFromMem(DataFromMem),
     .WB_PCadd4(WB_PCadd4),
     .WriteData(WriteData)
     );
     
     initial begin
     DataFromALU=32'd8;
     DataFromMem=32'd4;
     WB_PCadd4=32'd12;
     
     DBDataSrc=2'b00;
     #50;
     
     DBDataSrc=2'b01;
     #50;
     
     DBDataSrc=2'b10;
     #50;
     $stop;
     end
endmodule
