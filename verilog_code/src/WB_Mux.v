`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 16:39:50
// Design Name: 
// Module Name: WB_Mux
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

//选择写回寄存器堆的数据的来源
module WB_Mux(
    //控制信号
    input wire[1:0] DBDataSrc,
    
    //数据通路
    input wire[31:0] DataFromALU,DataFromMem,WB_PCadd4,
    
    output wire[31:0] WriteData
    );
    //选择写入数据的来源
    

    
    assign WriteData=(DBDataSrc==2'b10)?WB_PCadd4 //如果DBDataSrc=2，则写回PC+4
            :(DBDataSrc==2'b01)? DataFromMem      //如果DBDataSrc=1，则写回从Data Memory读取的数据
            :DataFromALU;                         //默认写回ALU的结果
    
endmodule
