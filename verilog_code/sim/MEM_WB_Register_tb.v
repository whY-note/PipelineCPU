`timescale 1ns / 1ps

module MEM_WB_Register_tb;

    // 控制信号
    reg Clk;
    //reg MEM_WB_Flush;

    // WB阶段的信号
    reg [1:0] MEM_DBDataSrc;
    wire [1:0] WB_DBDataSrc;

    reg MEM_RegWre;
    wire WB_RegWre;

    // 数据通路信号
    reg [31:0] MEM_PCadd4;
    wire [31:0] WB_PCadd4;
     
    reg [31:0] MEM_DataFromMemory;
    wire [31:0] WB_DataFromMemory;

    reg [31:0] MEM_DataFromALU;
    wire [31:0] WB_DataFromALU;

    reg [4:0] MEM_WriteReg;
    wire [4:0] WB_WriteReg;

    // 例化 MEM_WB_Register 模块
    MEM_WB_Register mem_wb_register (
        .Clk(Clk),
        //.MEM_WB_Flush(MEM_WB_Flush),
        .MEM_DBDataSrc(MEM_DBDataSrc),
        .WB_DBDataSrc(WB_DBDataSrc),
        .MEM_RegWre(MEM_RegWre),
        .WB_RegWre(WB_RegWre),
        .MEM_PCadd4(MEM_PCadd4),
        .WB_PCadd4(WB_PCadd4),
        .MEM_DataFromMemory(MEM_DataFromMemory),
        .WB_DataFromMemory(WB_DataFromMemory),
        .MEM_DataFromALU(MEM_DataFromALU),
        .WB_DataFromALU(WB_DataFromALU),
        .MEM_WriteReg(MEM_WriteReg),
        .WB_WriteReg(WB_WriteReg)
    );

    // 时钟信号生成
    always begin
        #50 Clk = ~Clk;
    end

    // 初始化信号
    initial begin
        // 初始化时钟
        Clk = 0;

        // 初始化输入信号
        MEM_PCadd4=32'h12341234;
        MEM_DBDataSrc = 1;
        MEM_RegWre = 1;
        MEM_DataFromMemory = 32'hA5A5A5A5;
        MEM_DataFromALU = 32'h5A5A5A5A;
        MEM_WriteReg = 5'b10101;

        // 仿真开始
        #100;
        
        MEM_PCadd4=32'h12;
        MEM_DBDataSrc = 2;
        MEM_RegWre = 1;
        MEM_DataFromMemory = 32'hA5;
        MEM_DataFromALU = 32'h5A;
        MEM_WriteReg = 5'b10;
        #100;

        // 停止仿真
        $stop;
    end

endmodule
