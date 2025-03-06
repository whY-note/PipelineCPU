`timescale 1ns / 1ps
//选择写入的寄存器编号

module RegDst_Mux(
    //控制信号
    input wire[1:0] RegDst,
    
    //数据通路
    input wire[4:0] rt,rd,
    output wire [4:0] WriteReg
    );
    
    // MUX选择：根据RegDst选择目标寄存器
    // 如果RegDst是 00，选择rt；如果RegDst是 01，选择rd；如果RegDst是 10，选择$31（用于jal等指令）。
    assign WriteReg=(RegDst==2'b00)? rt:
                    (RegDst==2'b01)? rd:
                     5'd31;
                     
endmodule
