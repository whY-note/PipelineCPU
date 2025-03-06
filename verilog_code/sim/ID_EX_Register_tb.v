`timescale 1ns / 1ps

module ID_EX_Register_tb();

    // 输入信号
    reg Clk, ID_EX_Flush;

    // EX阶段的信号
    reg ID_ALUSrcB;       // input
    wire EX_ALUSrcB;       // output

    reg [3:0] ID_ALUOp;   // input
    wire [3:0] EX_ALUOp;   // output

    reg [1:0] ID_RegDst;        // input
    wire [1:0] EX_RegDst;        // output

    // MEM阶段的信号
    reg ID_MemWre;        // input
    wire EX_MemWre;        // output

    reg ID_MemRead;       // input
    wire EX_MemRead;       // output

    reg [1:0] ID_BranchType;  // input
    wire [1:0] EX_BranchType;  // output

    // WB阶段的信号
    reg [1:0]ID_DBDataSrc;     // input
    wire [1:0]EX_DBDataSrc;     // output

    reg ID_RegWre;        // input
    wire EX_RegWre;        // output

    // 数据通路信号
    reg [31:0] ID_PCadd4;     // input
    wire [31:0] EX_PCadd4;     // output

    reg [31:0] ID_ReadData1, ID_ReadData2;   // input
    wire [31:0] EX_ReadData1, EX_ReadData2;   // output

    reg [4:0] ID_sa, ID_rs, ID_rt, ID_rd;    // input
    wire [4:0] EX_sa, EX_rs, EX_rt, EX_rd;    // output

    reg [31:0] ID_Immediate32;   // input
    wire [31:0] EX_Immediate32;   // output

    reg [5:0] ID_func;           // input
    wire [5:0] EX_func;           // output

    // 例化ID_EX_Register模块
    ID_EX_Register id_ex_register (
        .Clk(Clk),
        .ID_EX_Flush(ID_EX_Flush),
        .ID_ALUSrcB(ID_ALUSrcB),
        .EX_ALUSrcB(EX_ALUSrcB),
        .ID_ALUOp(ID_ALUOp),
        .EX_ALUOp(EX_ALUOp),
        .ID_RegDst(ID_RegDst),
        .EX_RegDst(EX_RegDst),
        .ID_MemWre(ID_MemWre),
        .EX_MemWre(EX_MemWre),
        .ID_MemRead(ID_MemRead),
        .EX_MemRead(EX_MemRead),
        .ID_BranchType(ID_BranchType),
        .EX_BranchType(EX_BranchType),
        .ID_DBDataSrc(ID_DBDataSrc),
        .EX_DBDataSrc(EX_DBDataSrc),
        .ID_RegWre(ID_RegWre),
        .EX_RegWre(EX_RegWre),
        .ID_PCadd4(ID_PCadd4),
        .EX_PCadd4(EX_PCadd4),
        .ID_ReadData1(ID_ReadData1),
        .EX_ReadData1(EX_ReadData1),
        .ID_ReadData2(ID_ReadData2),
        .EX_ReadData2(EX_ReadData2),
        .ID_sa(ID_sa),
        .EX_sa(EX_sa),
        .ID_rs(ID_rs),
        .EX_rs(EX_rs),
        .ID_rt(ID_rt),
        .EX_rt(EX_rt),
        .ID_rd(ID_rd),
        .EX_rd(EX_rd),
        .ID_Immediate32(ID_Immediate32),
        .EX_Immediate32(EX_Immediate32),
        .ID_func(ID_func),
        .EX_func(EX_func)
    );

    // 生成时钟信号
    always begin
        #50 Clk = ~Clk;  // 每50ns翻转一次时钟信号
    end

    initial begin
        // 初始化信号
        Clk = 0;
        ID_EX_Flush = 0;
        
        ID_ALUSrcB = 1;
        ID_ALUOp = 4'b0001;
        ID_RegDst = 2;
        ID_MemWre = 1;  
        ID_MemRead = 1;
        ID_BranchType = 2'b01;
        ID_DBDataSrc = 2;   
        ID_RegWre = 1;
        ID_PCadd4 = 32'h00000004; 
        ID_ReadData1 = 32'h00000010;
        ID_ReadData2 = 32'h00000020;
        ID_sa = 5'b00001;
        ID_rs = 5'b00010;
        ID_rt = 5'b00100;
        ID_rd = 5'b01000;
        ID_Immediate32 = 32'h0000FFFF;
        ID_func = 6'b100000;

        // 启动仿真
        #100;
        
        // 激活flush信号
        ID_EX_Flush = 1;
        #100;
        
        ID_EX_Flush = 0;
        #100;
        $stop;
    end

endmodule

