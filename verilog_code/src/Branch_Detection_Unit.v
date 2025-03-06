`timescale 1ns / 1ps

module Branch_Detection_Unit(
    //控制信号
    input wire [1:0] MEM_BranchType,
   
    //数据通路
    input wire MEM_Zero, MEM_Sign,
    output reg Branch
    );
    always @(*) begin
        if(MEM_BranchType==2'b01 && MEM_Zero==1) Branch=1;//是beq指令,且计算结果为0（说明相等），要分支
        else if(MEM_BranchType==2'b10 && MEM_Zero==0) Branch=1;//是bne指令,且计算结果不为0（说明不相等），要分支
        else if(MEM_BranchType==2'b11 && MEM_Sign==1) Branch=1;//是bltz指令,且计算结果为<0，要分支
        else Branch=0; //不是分支指令，则不分支
    end
    
endmodule
