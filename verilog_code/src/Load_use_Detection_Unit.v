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
    //控制信号
    input wire EX_MemRead,
    input wire Reset,//新增Reset,重置信号，1:重置为初始值;0:不重置
    
    output reg PCWre,IF_ID_Wre,ControlSrc,
    
    //数据通路
    input wire [4:0] EX_rt,ID_rs,ID_rt
    );
    
    always @(*) begin
    
        //初始情况
        if(Reset==1) begin
            IF_ID_Wre=1;//把 IF_ID_Wre 置为1，否则第一条指令无法写入 IF_ID_Register，导致所有指令都无法正常执行
            PCWre=1;
        end
        
        else begin
            if(EX_MemRead==1 &&(EX_rt==ID_rs || EX_rt==ID_rt) ) begin
                    PCWre=0;
                    IF_ID_Wre=0;
                    ControlSrc=1;
            end
            
            else begin
                //默认是正常情况，不用阻塞
                PCWre=1;
                IF_ID_Wre=1;
                ControlSrc=0;
            end
        end
    end

endmodule
