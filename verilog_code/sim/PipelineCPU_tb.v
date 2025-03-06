`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 09:25:51
// Design Name: 
// Module Name: PipelineCPU_tb
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


module PipelineCPU_tb( );

     //inputs
    reg Clk,Reset;
    
    //output
    wire[31:0] EX_ALUResult;//ALU运算结果
    wire[31:0] PCAddress,nextPCAddress; //PC的地址
    
    //例化
    PipelineCPU PCPU(
    .Clk(Clk),
    .Reset(Reset),
    .EX_ALUResult(EX_ALUResult),
    .PCAddress(PCAddress),
    .nextPCAddress(nextPCAddress) 
    );
    
    initial begin 

        //初始化
        Clk= 1;
        Reset = 1;//刚开始设置PC为0

        #10;
        Clk = 0;
        Reset = 0;

        //产生时钟信号
        forever #10
        begin
            Clk = !Clk;
        end

    
    $stop;
    end
    
    
endmodule
