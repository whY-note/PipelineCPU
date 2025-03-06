`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 19:27:37
// Design Name: 
// Module Name: Forwarding_Unit
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


module Forwarding_Unit(
    //�����ź�
    input wire MEM_RegWre,WB_RegWre,
    output reg [1:0] ForwardA,ForwardB,
        
    //����ͨ·
    input wire [4:0] EX_rs,EX_rt,MEM_WriteReg,WB_WriteReg
    );
    
    always @(*) begin
        //Ĭ�� ��ת��
        ForwardA=2'b00;
        ForwardB=2'b00;
        
        //��MEM�׶ε�EX�׶ε���·
        if(MEM_RegWre==1 && MEM_WriteReg!=0) begin  
            if(EX_rs==MEM_WriteReg) begin      //���MEM�׶ε�WriteReg��EX�׶ε�rs��ͬ��˵��Ҫ����·ת��
                 ForwardA=2'b10;
            end
            
            if(EX_rt==MEM_WriteReg) begin //���MEM�׶ε�WriteReg��EX�׶ε�rt��ͬ��˵��Ҫ����·ת��
                 ForwardB=2'b10;               //���MEM�׶ε�EX�׶�ת��
            end
            
        end
        
        //��WB�׶ε�EX�׶ε���·
        if(WB_RegWre==1 && WB_WriteReg!=0) begin
            
            if(EX_rs==WB_WriteReg) begin       //���WB�׶ε�WriteReg��EX�׶ε�rs��ͬ��
                if(!(MEM_RegWre==1 && MEM_WriteReg!=0 && EX_rs==MEM_WriteReg)) begin //���� MEM�׶ε�WriteReg��EX�׶ε�rs��ͬ
                    ForwardA=2'b01;            //���WB�׶ε�EX�׶�ת��
                end
            end

            if(EX_rt==WB_WriteReg) begin   //���WB�׶ε�WriteReg��EX�׶ε�rt��ͬ��
                if(!(MEM_RegWre==1 && MEM_WriteReg!=0 && EX_rt==MEM_WriteReg)) begin //���� MEM�׶ε�WriteReg��EX�׶ε�rt��ͬ
                     ForwardB=2'b01;            //���WB�׶ε�EX�׶�ת��
                end
            end
        end
    end
endmodule
