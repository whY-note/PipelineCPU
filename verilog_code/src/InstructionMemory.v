`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 16:32:26
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(
    input wire[31:0] InstructionAddress,
    
    //取出的32位的指令
    output reg [31:0] Instruction
    );
    //指令存储器，8位为1个字节，共128字节
    reg [7:0] Memory[127:0];

    initial begin
//    //测试硬件中的nop指令（addi $0,$0,0)
//    //001001 00000 00000 0000 0000 0000 0000
//        Memory[0]=8'b00100100;
//        Memory[1]=8'b00000000;
//        Memory[2]=8'b00000000;
//        Memory[3]=8'b00000000;
    //方法1：从文件中导入指令
        //$readmemb("Pipeline_CPU_Instructions.txt", Memory);//导入
    //方法2：自己人工输入，这样就能够烧入板中
        Memory[0]=8'b00100100;
        Memory[1]=8'b00000001;
        Memory[2]=8'b00000000;
        Memory[3]=8'b00001000;
        Memory[4]=8'b00110100;
        Memory[5]=8'b00000010;
        Memory[6]=8'b00000000;
        Memory[7]=8'b00000010;
        Memory[8]=8'b00111000;
        Memory[9]=8'b01000011;
        Memory[10]=8'b00000000;
        Memory[11]=8'b00001000;
        Memory[12]=8'b00000000;
        Memory[13]=8'b01100001;
        Memory[14]=8'b00100000;
        Memory[15]=8'b00100010;
        Memory[16]=8'b00000000;
        Memory[17]=8'b10000010;
        Memory[18]=8'b00101000;
        Memory[19]=8'b00100100;
        Memory[20]=8'b00000000;
        Memory[21]=8'b00000101;
        Memory[22]=8'b00101000;
        Memory[23]=8'b10000000;
        Memory[24]=8'b00010000;
        Memory[25]=8'b10100001;
        Memory[26]=8'b11111111;
        Memory[27]=8'b11111110;
        Memory[28]=8'b00001100;
        Memory[29]=8'b00000000;
        Memory[30]=8'b00000000;
        Memory[31]=8'b00010100;
        Memory[32]=8'b00000001;
        Memory[33]=8'b10100001;
        Memory[34]=8'b01000000;
        Memory[35]=8'b00101010;
        Memory[36]=8'b00100100;
        Memory[37]=8'b00001110;
        Memory[38]=8'b11111111;
        Memory[39]=8'b11111110;
        Memory[40]=8'b00000001;
        Memory[41]=8'b00001110;
        Memory[42]=8'b01001000;
        Memory[43]=8'b00101010;
        Memory[44]=8'b00101001;
        Memory[45]=8'b00101010;
        Memory[46]=8'b00000000;
        Memory[47]=8'b00000010;
        Memory[48]=8'b00101001;
        Memory[49]=8'b01001011;
        Memory[50]=8'b00000000;
        Memory[51]=8'b00000000;
        Memory[52]=8'b00000001;
        Memory[53]=8'b01101010;
        Memory[54]=8'b01011000;
        Memory[55]=8'b00100000;
        Memory[56]=8'b00010101;
        Memory[57]=8'b01100010;
        Memory[58]=8'b11111111;
        Memory[59]=8'b11111110;
        Memory[60]=8'b00100100;
        Memory[61]=8'b00001100;
        Memory[62]=8'b11111111;
        Memory[63]=8'b11111110;
        Memory[64]=8'b00100101;
        Memory[65]=8'b10001100;
        Memory[66]=8'b00000000;
        Memory[67]=8'b00000001;
        Memory[68]=8'b00000101;
        Memory[69]=8'b10000000;
        Memory[70]=8'b11111111;
        Memory[71]=8'b11111110;
        Memory[72]=8'b00110000;
        Memory[73]=8'b01001100;
        Memory[74]=8'b00000000;
        Memory[75]=8'b00000010;
        Memory[76]=8'b00001000;
        Memory[77]=8'b00000000;
        Memory[78]=8'b00000000;
        Memory[79]=8'b00010111;
        Memory[80]=8'b10101100;
        Memory[81]=8'b00100010;
        Memory[82]=8'b00000000;
        Memory[83]=8'b00000100;
        Memory[84]=8'b10001100;
        Memory[85]=8'b00101101;
        Memory[86]=8'b00000000;
        Memory[87]=8'b00000100;
        Memory[88]=8'b00000011;
        Memory[89]=8'b11100000;
        Memory[90]=8'b00000000;
        Memory[91]=8'b00001000;
        Memory[92]=8'b11111100;
        Memory[93]=8'b00000000;
        Memory[94]=8'b00000000;
        Memory[95]=8'b00000000;

        Instruction<= 0;//指令初始化
    end
    
    //取指令
    always@ (InstructionAddress) begin
        Instruction[31:24]<=Memory[InstructionAddress];
        Instruction[23:16]<=Memory[InstructionAddress+1];
        Instruction[15: 8]<=Memory[InstructionAddress+2];
        Instruction[ 7: 0]<=Memory[InstructionAddress+3];
    end

endmodule
