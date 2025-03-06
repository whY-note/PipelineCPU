`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 16:32:26
// Design Name: 
// Module Name: DataMemory
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

module DataMemory(
    //控制信号
    input wire MemWre,
    input wire MemRead,
    input wire Clk,

    //数据通路
    input wire[31:0] DataAddress,DataIn,
    
    output reg [31:0] DataOut
    );
    //存储器,以8位为一字节，共128字节
    reg [7:0] Memory[0:63];
    
    //初始化存储器为0
    integer i;
    initial begin
        for(i=0;i<128;i=i+1)
            Memory[i]<=0;
    end
    
    //读取数据
    //当MemRead==1时，才可以读取
    always@(*)
    begin
        if(MemRead) begin
            DataOut[31:24]<=Memory[DataAddress];
            DataOut[23:16]<=Memory[DataAddress+1];
            DataOut[15:8]<=Memory[DataAddress+2];
            DataOut[7:0]<=Memory[DataAddress+3];
        end
        else begin
            DataOut = 32'bz;  // 如果 MemRead 为 0，输出高阻态z
        end
    end
    
    //写入数据
    //当时钟下降沿来临时，且MemWre==1，才可以写入
    always @(negedge Clk)begin
        if(MemWre) begin
            Memory[DataAddress]<=DataIn[31:24];
            Memory[DataAddress+1]<=DataIn[23:16];
            Memory[DataAddress+2]<=DataIn[15:8];
            Memory[DataAddress+3]<=DataIn[7:0];
        end
    end
endmodule