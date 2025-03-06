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
    //控制信号
    input wire MEM_RegWre,WB_RegWre,
    output reg [1:0] ForwardA,ForwardB,
        
    //数据通路
    input wire [4:0] EX_rs,EX_rt,MEM_WriteReg,WB_WriteReg
    );
    
    always @(*) begin
        //默认 不转发
        ForwardA=2'b00;
        ForwardB=2'b00;
        
        //从MEM阶段到EX阶段的旁路
        if(MEM_RegWre==1 && MEM_WriteReg!=0) begin  
            if(EX_rs==MEM_WriteReg) begin      //如果MEM阶段的WriteReg与EX阶段的rs相同，说明要用旁路转发
                 ForwardA=2'b10;
            end
            
            if(EX_rt==MEM_WriteReg) begin //如果MEM阶段的WriteReg与EX阶段的rt相同，说明要用旁路转发
                 ForwardB=2'b10;               //则从MEM阶段到EX阶段转发
            end
            
        end
        
        //从WB阶段到EX阶段的旁路
        if(WB_RegWre==1 && WB_WriteReg!=0) begin
            
            if(EX_rs==WB_WriteReg) begin       //如果WB阶段的WriteReg与EX阶段的rs相同，
                if(!(MEM_RegWre==1 && MEM_WriteReg!=0 && EX_rs==MEM_WriteReg)) begin //并且 MEM阶段的WriteReg与EX阶段的rs不同
                    ForwardA=2'b01;            //则从WB阶段到EX阶段转发
                end
            end

            if(EX_rt==WB_WriteReg) begin   //如果WB阶段的WriteReg与EX阶段的rt相同，
                if(!(MEM_RegWre==1 && MEM_WriteReg!=0 && EX_rt==MEM_WriteReg)) begin //并且 MEM阶段的WriteReg与EX阶段的rt不同
                     ForwardB=2'b01;            //则从WB阶段到EX阶段转发
                end
            end
        end
    end
endmodule
