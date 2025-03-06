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


module MEM_WB_Register(
     //控制信号
     input wire Clk,//MEM_WB_Flush,
     
     
     //WB阶段的信号
     input wire [1:0] MEM_DBDataSrc,
     output reg [1:0] WB_DBDataSrc,
     
     input wire MEM_RegWre,
     output reg WB_RegWre,
    
    
    //数据通路
    input wire [31:0] MEM_PCadd4,
    output reg [31:0] WB_PCadd4,
    
    input wire [31:0] MEM_DataFromMemory,
    output reg [31:0] WB_DataFromMemory,
    
    input wire [31:0] MEM_DataFromALU,
    output reg [31:0] WB_DataFromALU,
    
    input wire [4:0] MEM_WriteReg,
    output reg [4:0] WB_WriteReg
    );
    
    //初始化
    initial begin
    
        WB_DBDataSrc=0;
        WB_RegWre=0;
        
        WB_PCadd4=0;
        WB_DataFromALU=0;
        WB_DataFromMemory=0;
        WB_WriteReg=0;
    end
    
     //写入
    always @(negedge Clk) begin 
       //if(MEM_WB_Flush==0) begin
            
            //WB阶段的信号
            WB_DBDataSrc<=MEM_DBDataSrc;
            WB_RegWre<=MEM_RegWre;
            
            //数据通路
            WB_PCadd4<=MEM_PCadd4;
            WB_DataFromMemory<=MEM_DataFromMemory;
            WB_DataFromALU<=MEM_DataFromALU;
            WB_WriteReg<=MEM_WriteReg;
       //end
    end
    
    //不需要处理分支
//    //处理分支
//    always @(*)begin
//        if(MEM_WB_Flush==1) begin     

//            //WB阶段的信号
//            WB_DBDataSrc=0;
//            WB_RegWre=0;
            
//            //数据通路
//            WB_DataFromMemory=0;
//            WB_DataFromALU=0;
//            WB_WriteReg=0;
//        end
//    end
endmodule
