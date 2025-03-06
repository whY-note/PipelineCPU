`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 16:32:26
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    //控制信号
    input wire Clk,RegWre,
    
    //数据通路
    input wire[4:0] rs,rt,WriteReg,
    input wire[31:0] WriteData,
    
    output wire[31:0] ReadData1,ReadData2

    //用于debug
    //output wire[31:0] regData31
    );
    
    
    //初始化寄存器
    reg [31:0] register[0:31];//32个寄存器，每个寄存器32位
    integer i;
    initial begin
        for(i = 0;i < 32;i=i+1) 
            register[i] <= 0;//每个寄存器初始化为0
    end
    
    //读取部分（组合逻辑电路）
    wire[4:0] ReadReg1,ReadReg2;
    assign ReadReg1=rs;
    assign ReadReg2=rt;
    assign ReadData1=register[ReadReg1];
    assign ReadData2=register[ReadReg2];
    
    //写入部分（组合逻辑电路）
    //当时钟下降沿来临时，且RegWre==1，才可以写入
    always @(posedge Clk) begin
        if((RegWre==1)&& (WriteReg!=0))//避免写入0号寄存器
            register[WriteReg]<= WriteData;
    end
    
    
    //用于debug
    //assign regData31=register[31];
    
endmodule
