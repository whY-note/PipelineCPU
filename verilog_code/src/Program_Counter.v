`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/11 17:49:10
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    //�����ź�
    input wire Clk,
    input wire Reset,//�����źţ�1:����;0:������
    
    input wire PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit,
    input wire[1:0] PCSrc,
    
    input wire JumpPCSrc,
    
    //����ͨ·
    input wire [25:0] ID_targetAddress,//��תָ��ĵ�26λ
    input wire [31:0] ID_PCadd4,
    input wire [31:0] ID_ReadData1,//��rs����������
    
    input wire [31:0] MEM_BranchPC,//��MEM�������ķ�֧��ַ
    
    output wire [31:0] IF_PCadd4,
    output reg [31:0] currAddress,
    output wire [31:0] nextPCAddress
    );
    
    // PC+4
    assign IF_PCadd4=currAddress+4;
    
    //ѡ��JumpPC����Դ
    //����j,jalָ��JumpPCSrc==1; ����jrָ��,JumpPCSrc==0
    wire [31:0] JumpPC;
    assign JumpPC=(JumpPCSrc==1)? {ID_PCadd4[31:28],ID_targetAddress,2'b00}:ID_ReadData1;
    
    assign nextPCAddress=(PCSrc==2'b10)? JumpPC://��תָ��
                         (PCSrc==2'b01)? MEM_BranchPC://��ָ֧�����ת
                         IF_PCadd4;//˳��ִ����һ��ָ��
    
    
    //Clk�������ص���ʱд���µ�PC
    always @(posedge Clk or posedge Reset) begin
        if(Reset==1) currAddress<=0;//����
        
        else if(PCWre_from_Control_Unit==1 && PCWre_from_Load_use_Detection_Unit==1) begin //дPC
            if(PCSrc==0)//˳��ִ����һ��ָ��
                currAddress<=IF_PCadd4;
            else if(PCSrc==2'b01)//��ָ֧�����ת
                currAddress<=MEM_BranchPC;
            else if(PCSrc==2'b10)//��תָ��
               currAddress<=JumpPC;
        end    
        //��������£�
        //PCWre_from_Control_Unit==1 ���� PCWre_from_Load_use_Detection_Unit==1
        //currAddress�����ֲ���
    end
endmodule
