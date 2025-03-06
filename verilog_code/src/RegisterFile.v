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
    //�����ź�
    input wire Clk,RegWre,
    
    //����ͨ·
    input wire[4:0] rs,rt,WriteReg,
    input wire[31:0] WriteData,
    
    output wire[31:0] ReadData1,ReadData2

    //����debug
    //output wire[31:0] regData31
    );
    
    
    //��ʼ���Ĵ���
    reg [31:0] register[0:31];//32���Ĵ�����ÿ���Ĵ���32λ
    integer i;
    initial begin
        for(i = 0;i < 32;i=i+1) 
            register[i] <= 0;//ÿ���Ĵ�����ʼ��Ϊ0
    end
    
    //��ȡ���֣�����߼���·��
    wire[4:0] ReadReg1,ReadReg2;
    assign ReadReg1=rs;
    assign ReadReg2=rt;
    assign ReadData1=register[ReadReg1];
    assign ReadData2=register[ReadReg2];
    
    //д�벿�֣�����߼���·��
    //��ʱ���½�������ʱ����RegWre==1���ſ���д��
    always @(posedge Clk) begin
        if((RegWre==1)&& (WriteReg!=0))//����д��0�żĴ���
            register[WriteReg]<= WriteData;
    end
    
    
    //����debug
    //assign regData31=register[31];
    
endmodule
