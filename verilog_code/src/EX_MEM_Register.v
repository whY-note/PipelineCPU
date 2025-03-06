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


module EX_MEM_Register(
     //输入信号
     input wire Clk,EX_MEM_Flush,
    
    
     //MEM阶段的控制信号
     input wire EX_MemWre,
     output reg MEM_MemWre,
     
     input wire EX_MemRead,
     output reg MEM_MemRead,
     
     input wire[1:0] EX_BranchType,
     output reg[1:0] MEM_BranchType,
     
     
     //WB阶段的控制信号
     input wire[1:0] EX_DBDataSrc,
     output reg[1:0] MEM_DBDataSrc,
     
     input wire EX_RegWre,
     output reg MEM_RegWre,
    
    
     //数据通路
    input wire [31:0] EX_PCadd4,
    output reg [31:0] MEM_PCadd4,
    
    input wire [31:0] EX_BranchPC,
    output reg [31:0] MEM_BranchPC,
    
    input wire EX_Zero,EX_Sign,
    output reg MEM_Zero,MEM_Sign,
    
    input wire [31:0] EX_DataIn,
    output reg [31:0] MEM_DataIn,
    
    input wire [31:0] EX_ALUResult,
    output reg [31:0] MEM_ALUResult,
    
    input wire[4:0] EX_WriteReg,
    output reg[4:0] MEM_WriteReg
    );
    
    initial begin
        MEM_MemWre=0;
        MEM_MemRead=0;
        MEM_BranchType=0;
        MEM_RegWre=0;
        MEM_DBDataSrc=0;
        
        MEM_PCadd4=0;
        MEM_BranchPC=0;
        MEM_Zero=0;
        MEM_Sign=0;
        MEM_DataIn=0;
        MEM_ALUResult=0;
        MEM_WriteReg=0;
    end
    
     
    always @(negedge Clk or posedge Clk) begin 
        if(Clk==0) begin
           if(EX_MEM_Flush==0) begin
                
                //MEM阶段的控制信号
                MEM_MemWre<=EX_MemWre;
                MEM_MemRead<=EX_MemRead;
                MEM_BranchType<=EX_BranchType;
                
                //WB阶段的控制信号
                MEM_DBDataSrc<=EX_DBDataSrc;
                MEM_RegWre<=EX_RegWre;
                
                 //数据通路
                MEM_PCadd4<=EX_PCadd4;
                MEM_BranchPC<=EX_BranchPC;
                MEM_Zero<=EX_Zero;
                MEM_Sign<=EX_Sign;
                MEM_DataIn<=EX_DataIn;
                MEM_ALUResult<=EX_ALUResult;
                MEM_WriteReg<=EX_WriteReg;
           end
        end
        
        else //Clk==1
        begin
            if(EX_MEM_Flush==1)//处理分支
            begin     
                //MEM阶段的控制信号
                MEM_MemWre=0;
                MEM_MemRead=0;           
                MEM_BranchType=0;// 保持原有的值 错
                
                //WB阶段的控制信号
                MEM_DBDataSrc=0;
                MEM_RegWre=0;
                
                //数据通路
                MEM_PCadd4=0;
                //MEM_BranchPC=0;// 保持原有的值
                MEM_Zero=0;// 保持原有的值 错
                MEM_Sign=0;// 保持原有的值 错
                MEM_DataIn=0;
                MEM_ALUResult=0;
                MEM_WriteReg=0;
            end
        end
    end
    
//    //处理分支
//    always @(posedge Clk) begin 
//        if(EX_MEM_Flush==1)//处理分支
//        begin     
//            //MEM阶段的控制信号
//            MEM_MemWre=0;
//            MEM_MemRead=0;           
//            MEM_BranchType=0;// 保持原有的值 错
            
//            //WB阶段的控制信号
//            MEM_DBDataSrc=0;
//            MEM_RegWre=0;
            
//            //数据通路
//            MEM_PCadd4=0;
//            //MEM_BranchPC=0;// 保持原有的值
//            MEM_Zero=0;// 保持原有的值 错
//            MEM_Sign=0;// 保持原有的值 错
//            MEM_DataIn=0;
//            MEM_ALUResult=0;
//            MEM_WriteReg=0;
//        end
//    end
    
    
    
//    //处理分支
//    always @(*)begin
//        if(EX_MEM_Flush==1) begin     
//            //MEM阶段的控制信号
//            MEM_MemWre=0;
//            MEM_MemRead=0;           
//            MEM_BranchType=0;// 保持原有的值 错
            
//            //WB阶段的控制信号
//            MEM_DBDataSrc=0;
//            MEM_RegWre=0;
            
//            //数据通路
//            MEM_PCadd4=0;
//            //MEM_BranchPC=0;// 保持原有的值
//            MEM_Zero=0;// 保持原有的值 错
//            MEM_Sign=0;// 保持原有的值 错
//            MEM_DataIn=0;
//            MEM_ALUResult=0;
//            MEM_WriteReg=0;
//        end
//    end
endmodule
