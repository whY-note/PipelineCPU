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
    wire[31:0] EX_ALUResult;//ALU������
    wire[31:0] PCAddress,nextPCAddress; //PC�ĵ�ַ
    
    //����
    PipelineCPU PCPU(
    .Clk(Clk),
    .Reset(Reset),
    .EX_ALUResult(EX_ALUResult),
    .PCAddress(PCAddress),
    .nextPCAddress(nextPCAddress) 
    );
    
    initial begin 

        //��ʼ��
        Clk= 1;
        Reset = 1;//�տ�ʼ����PCΪ0

        #10;
        Clk = 0;
        Reset = 0;

        //����ʱ���ź�
        forever #10
        begin
            Clk = !Clk;
        end

    
    $stop;
    end
    
    
endmodule
