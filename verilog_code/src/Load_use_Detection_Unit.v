`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 20:26:08
// Design Name: 
// Module Name: Load_use_Detection_Unit
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


module Load_use_Detection_Unit(
    //�����ź�
    input wire EX_MemRead,
    input wire Reset,//����Reset,�����źţ�1:����Ϊ��ʼֵ;0:������
    
    output reg PCWre,IF_ID_Wre,ControlSrc,
    
    //����ͨ·
    input wire [4:0] EX_rt,ID_rs,ID_rt
    );
    
    always @(*) begin
    
        //��ʼ���
        if(Reset==1) begin
            IF_ID_Wre=1;//�� IF_ID_Wre ��Ϊ1�������һ��ָ���޷�д�� IF_ID_Register����������ָ��޷�����ִ��
            PCWre=1;
        end
        
        else begin
            if(EX_MemRead==1 &&(EX_rt==ID_rs || EX_rt==ID_rt) ) begin
                    PCWre=0;
                    IF_ID_Wre=0;
                    ControlSrc=1;
            end
            
            else begin
                //Ĭ���������������������
                PCWre=1;
                IF_ID_Wre=1;
                ControlSrc=0;
            end
        end
    end

endmodule
