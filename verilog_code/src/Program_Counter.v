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
    //控制信号
    input wire Clk,
    input wire Reset,//置零信号，1:置零;0:不置零
    
    input wire PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit,
    input wire[1:0] PCSrc,
    
    input wire JumpPCSrc,
    
    //数据通路
    input wire [25:0] ID_targetAddress,//跳转指令的低26位
    input wire [31:0] ID_PCadd4,
    input wire [31:0] ID_ReadData1,//从rs读出的数据
    
    input wire [31:0] MEM_BranchPC,//从MEM级传来的分支地址
    
    output wire [31:0] IF_PCadd4,
    output reg [31:0] currAddress,
    output wire [31:0] nextPCAddress
    );
    
    // PC+4
    assign IF_PCadd4=currAddress+4;
    
    //选择JumpPC的来源
    //对于j,jal指令JumpPCSrc==1; 对于jr指令,JumpPCSrc==0
    wire [31:0] JumpPC;
    assign JumpPC=(JumpPCSrc==1)? {ID_PCadd4[31:28],ID_targetAddress,2'b00}:ID_ReadData1;
    
    assign nextPCAddress=(PCSrc==2'b10)? JumpPC://跳转指令
                         (PCSrc==2'b01)? MEM_BranchPC://分支指令的跳转
                         IF_PCadd4;//顺序执行下一条指令
    
    
    //Clk的上升沿到来时写入新的PC
    always @(posedge Clk or posedge Reset) begin
        if(Reset==1) currAddress<=0;//置零
        
        else if(PCWre_from_Control_Unit==1 && PCWre_from_Load_use_Detection_Unit==1) begin //写PC
            if(PCSrc==0)//顺序执行下一条指令
                currAddress<=IF_PCadd4;
            else if(PCSrc==2'b01)//分支指令的跳转
                currAddress<=MEM_BranchPC;
            else if(PCSrc==2'b10)//跳转指令
               currAddress<=JumpPC;
        end    
        //其余情况下：
        //PCWre_from_Control_Unit==1 或者 PCWre_from_Load_use_Detection_Unit==1
        //currAddress都保持不变
    end
endmodule
