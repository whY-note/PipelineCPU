`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 11:23:05
// Design Name: 
// Module Name: ALU_Control
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


module ALU_Control(
    //数据通路
    input wire [5:0] func,
    
    //控制信号
    input wire [3:0] ALUOp,
    
    output reg ALUSrcA,
    output reg [3:0] ALUCtr
    );
    
    always @(*) begin
        ALUSrcA=0;
        case(ALUOp)
            4'b1000://R型指令
                 case(func)
                    6'b100000://add
                        ALUCtr=4'b0000;
                    6'b100010://sub
                        ALUCtr=4'b0001;
                    6'b100100://and
                        ALUCtr=4'b0010;
                    6'b100101://or
                        ALUCtr=4'b0011;
                    6'b000000://left shift
                    begin
                        ALUCtr=4'b0100;
                        ALUSrcA=1;
                    end
                    6'b100110://xor
                        ALUCtr=4'b0111;
                    6'b101011://无符号比较:sltu
                        ALUCtr=4'b0101;
                    6'b101010://有符号比较:slt
                        ALUCtr=4'b0110;
                    default:
                         ALUCtr=4'b0000;
                 endcase
                 
            4'b0000://加法:addi,sw,lw
                ALUCtr=4'b0000;
            4'b0001://减法:beq,bne,bltz
                ALUCtr=4'b0001;
            4'b0010://位与:andi
                ALUCtr=4'b0010;
            4'b0011://位或:ori
                ALUCtr=4'b0011;
            4'b0101://无符号比较:sltiu
                 ALUCtr=4'b0101;
            4'b0110://有符号比较:slti
                 ALUCtr=4'b0110;
            4'b0111://异或:xori
                 ALUCtr=4'b0111;
            default:
                 ALUCtr=4'b0000;
        endcase
    end
endmodule
