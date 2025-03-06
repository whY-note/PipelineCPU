`timescale 1ns / 1ps


module ALU(
    //控制信号
    input wire [3:0] ALUCtr,
    input wire ALUSrcA,ALUSrcB,
    input wire [1:0] ForwardA,ForwardB,
    
    //数据通路
    input wire [31:0] ReadData1,ReadData2,
    input wire [4:0] sa,
    input wire [31:0] ExtData,
    input wire [31:0] WB_WriteData,MEM_ALUResult,
    
    output wire Zero,
    output wire Sign,
    output reg [31:0] EX_ALUResult,
    output reg [31:0] TempDataA,//要展示于Basys板的数据
    output reg [31:0] TempDataB //要写入Data Memory的数据，且是要展示于Basys板的数据
    );
    
    //初始化
    initial begin
        EX_ALUResult=0;
    end

    
    //选择转发的数据
    always @(*) begin
        case(ForwardA)
            2'b00:
                TempDataA=ReadData1;
            2'b01:
                TempDataA=WB_WriteData;
            2'b10:
                TempDataA=MEM_ALUResult;
            default:
                TempDataA=ReadData1;
        endcase
        
        case(ForwardB)
            2'b00:
                TempDataB=ReadData2;
            2'b01:
                TempDataB=WB_WriteData;
            2'b10:
                TempDataB=MEM_ALUResult;
            default:
                TempDataB=ReadData2;
        endcase
    end
    
    //两个输入数据A,B
    wire [31:0] InA;
    wire [31:0] InB;
    
    //A端：如果ALUSrcA==0，则输入ReadData1; ALUSrcA==1，则输入sa
    assign InA=(ALUSrcA==0)?TempDataA:{27'b0,sa};
    //B端：如果ALUSrcB==0，则输入ReadData2; ALUSrcB==1，则输入ExtData
    assign InB=(ALUSrcB==0)?TempDataB:ExtData;
    
    
    //进行计算
    always@(*) begin
        case(ALUCtr)
            4'b0000:
                EX_ALUResult=InA + InB;
            4'b0001:
                EX_ALUResult=InA - InB;
            4'b0010:
                EX_ALUResult=InA & InB;
            4'b0011:
                EX_ALUResult=InA | InB;
            4'b0100://左移
                EX_ALUResult=InB << InA;
            4'b0101://无符号比较
                EX_ALUResult=(InA<InB)? 1:0;
            4'b0110://有符号比较
                EX_ALUResult=((InA[31]==1 && InB[31]==0)||(InA<InB && InA[31]==InB[31]))? 1:0;
            4'b0111://异或
                EX_ALUResult=InB ^ InA;
            default:
                EX_ALUResult=32'b0;
        endcase
    end
    
    //求Zero
    assign Zero=(EX_ALUResult==0)?1:0;
    
    //求Sign
    assign Sign=EX_ALUResult[31];
    
endmodule

