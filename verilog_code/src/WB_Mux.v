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

//ѡ��д�ؼĴ����ѵ����ݵ���Դ
module WB_Mux(
    //�����ź�
    input wire[1:0] DBDataSrc,
    
    //����ͨ·
    input wire[31:0] DataFromALU,DataFromMem,WB_PCadd4,
    
    output wire[31:0] WriteData
    );
    //ѡ��д�����ݵ���Դ
    

    
    assign WriteData=(DBDataSrc==2'b10)?WB_PCadd4 //���DBDataSrc=2����д��PC+4
            :(DBDataSrc==2'b01)? DataFromMem      //���DBDataSrc=1����д�ش�Data Memory��ȡ������
            :DataFromALU;                         //Ĭ��д��ALU�Ľ��
    
endmodule
