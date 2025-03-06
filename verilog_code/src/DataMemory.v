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
    //�����ź�
    input wire MemWre,
    input wire MemRead,
    input wire Clk,

    //����ͨ·
    input wire[31:0] DataAddress,DataIn,
    
    output reg [31:0] DataOut
    );
    //�洢��,��8λΪһ�ֽڣ���128�ֽ�
    reg [7:0] Memory[0:63];
    
    //��ʼ���洢��Ϊ0
    integer i;
    initial begin
        for(i=0;i<128;i=i+1)
            Memory[i]<=0;
    end
    
    //��ȡ����
    //��MemRead==1ʱ���ſ��Զ�ȡ
    always@(*)
    begin
        if(MemRead) begin
            DataOut[31:24]<=Memory[DataAddress];
            DataOut[23:16]<=Memory[DataAddress+1];
            DataOut[15:8]<=Memory[DataAddress+2];
            DataOut[7:0]<=Memory[DataAddress+3];
        end
        else begin
            DataOut = 32'bz;  // ��� MemRead Ϊ 0���������̬z
        end
    end
    
    //д������
    //��ʱ���½�������ʱ����MemWre==1���ſ���д��
    always @(negedge Clk)begin
        if(MemWre) begin
            Memory[DataAddress]<=DataIn[31:24];
            Memory[DataAddress+1]<=DataIn[23:16];
            Memory[DataAddress+2]<=DataIn[15:8];
            Memory[DataAddress+3]<=DataIn[7:0];
        end
    end
endmodule