`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 15:43:18
// Design Name: 
// Module Name: ID_EX_Register
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


module ID_EX_Register(
    //�����ź�
    input wire Clk,ID_EX_Flush,
    
    //EX�׶ε��ź�
    input wire ID_ALUSrcB,
    output reg EX_ALUSrcB,
    
    input wire [3:0] ID_ALUOp,
    output reg [3:0] EX_ALUOp,
    
    input wire [1:0] ID_RegDst,
    output reg [1:0] EX_RegDst,
    
    
    //MEM�׶ε��ź�
    input wire ID_MemWre,
    output reg EX_MemWre,
    
    input wire ID_MemRead,
    output reg EX_MemRead,
    
    input wire[1:0] ID_BranchType,
    output reg[1:0] EX_BranchType,
    
    
    //WB�׶ε��ź�
    input wire [1:0]ID_DBDataSrc,
    output reg [1:0]EX_DBDataSrc,
    
    input wire ID_RegWre,
    output reg EX_RegWre,
    
    
    //����ͨ·
    input wire [31:0] ID_PCadd4,
    output reg [31:0] EX_PCadd4,
    
    input wire [31:0] ID_ReadData1,ID_ReadData2,
    output reg [31:0] EX_ReadData1,EX_ReadData2,
    
    input wire[4:0] ID_sa,ID_rs,ID_rt,ID_rd,
    output reg[4:0] EX_sa,EX_rs,EX_rt,EX_rd,
    
    input wire[31:0] ID_Immediate32,
    output reg[31:0] EX_Immediate32,
    
    input wire[5:0] ID_func,
    output reg[5:0] EX_func
    
    );
    
    //��ʼ��
    initial begin
        EX_ALUSrcB=0;
        EX_ALUOp=0;
        EX_DBDataSrc=0;
        EX_RegWre=0;
        EX_RegDst=0;
        EX_BranchType=0;
        EX_MemWre=0;
        EX_MemRead=0;
        
        EX_PCadd4=0;
        EX_ReadData1=0;
        EX_ReadData2=0;
        EX_sa=0;
        EX_rs=0;
        EX_rt=0;
        EX_rd=0;
        EX_Immediate32=0;
        EX_func=0;
        
    end
    
     //д��
    always @(negedge Clk or posedge Clk) begin 
       if(Clk==0) begin
           if(ID_EX_Flush==0) begin
                //EX�׶ε��ź�
                EX_ALUSrcB<=ID_ALUSrcB;
                EX_ALUOp<=ID_ALUOp;
                EX_RegDst<=ID_RegDst;
                
                //MEM�׶ε��ź�
                EX_MemWre<=ID_MemWre;
                EX_MemRead<=ID_MemRead;
                EX_BranchType<=ID_BranchType;
                
                //WB�׶ε��ź�
                EX_DBDataSrc<=ID_DBDataSrc;
                EX_RegWre<=ID_RegWre;
                
                //����ͨ·
                EX_PCadd4<=ID_PCadd4;
                EX_ReadData1<=ID_ReadData1;
                EX_ReadData2<=ID_ReadData2;
                EX_sa<=ID_sa;
                EX_rs<=ID_rs;
                EX_rt<=ID_rt;
                EX_rd<=ID_rd;
                EX_Immediate32<=ID_Immediate32;
                EX_func<=ID_func;
                
           end
       end
       
       else//Clk==1
       begin
            if(ID_EX_Flush==1) begin     
             //EX�׶ε��ź�
            EX_ALUSrcB=0;
            EX_ALUOp=8;//ģ��addiu $0,$0,0 ������nop 
            EX_RegDst=0;
            
            //MEM�׶ε��ź�
            EX_MemWre=0;
            EX_MemRead=0;
            EX_BranchType=0;
            
            //WB�׶ε��ź�
            EX_DBDataSrc=0;
            EX_RegWre=0;
            
            //����ͨ·
            EX_PCadd4=0;
            EX_ReadData1=0;
            EX_ReadData2=0;
            EX_sa=0;
            EX_rs=0;
            EX_rt=0;
            EX_rd=0;
            EX_Immediate32=0;
            EX_func=0;
           end
       end
    end
    
//    //�����֧
//    always @(posedge Clk)begin
//        if(ID_EX_Flush==1) begin     
//             //EX�׶ε��ź�
//            EX_ALUSrcB=0;
//            EX_ALUOp=8;//ģ��addiu $0,$0,0 ������nop 
//            EX_RegDst=0;
            
//            //MEM�׶ε��ź�
//            EX_MemWre=0;
//            EX_MemRead=0;
//            EX_BranchType=0;
            
//            //WB�׶ε��ź�
//            EX_DBDataSrc=0;
//            EX_RegWre=0;
            
//            //����ͨ·
//            EX_PCadd4=0;
//            EX_ReadData1=0;
//            EX_ReadData2=0;
//            EX_sa=0;
//            EX_rs=0;
//            EX_rt=0;
//            EX_rd=0;
//            EX_Immediate32=0;
//            EX_func=0;
//        end
//    end
    

endmodule
