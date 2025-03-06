`timescale 1ns / 1ps

module EX_MEM_Register_tb;
    
    // �����ź�
    reg Clk;
    reg EX_MEM_Flush;

    // MEM�׶ε��ź�
    reg EX_MemWre;
    wire MEM_MemWre;

    reg EX_MemRead;
    wire MEM_MemRead;

    reg [1:0] EX_BranchType;
    wire [1:0] MEM_BranchType;

    // WB�׶ε��ź�
    reg [1:0] EX_DBDataSrc;
    wire [1:0] MEM_DBDataSrc;

    reg EX_RegWre;
    wire MEM_RegWre;

    // ����ͨ·
    reg [31:0] EX_PCadd4;
    wire [31:0] MEM_PCadd4;
    
    reg [31:0] EX_BranchPC;
    wire [31:0] MEM_BranchPC;

    reg EX_Zero;
    wire MEM_Zero;

    reg EX_Sign;
    wire MEM_Sign;

    reg [31:0] EX_DataIn;
    wire [31:0] MEM_DataIn;

    reg [31:0] EX_ALUResult;
    wire [31:0] MEM_ALUResult;

    reg [4:0] EX_WriteReg;
    wire [4:0] MEM_WriteReg;

    // ����EX_MEM_Registerģ��
    EX_MEM_Register ex_mem_register (
        .Clk(Clk),
        .EX_MEM_Flush(EX_MEM_Flush),
        .EX_MemWre(EX_MemWre),
        .MEM_MemWre(MEM_MemWre),
        .EX_MemRead(EX_MemRead),
        .MEM_MemRead(MEM_MemRead),
        .EX_BranchType(EX_BranchType),
        .MEM_BranchType(MEM_BranchType),
        .EX_DBDataSrc(EX_DBDataSrc),
        .MEM_DBDataSrc(MEM_DBDataSrc),
        .EX_RegWre(EX_RegWre),
        .MEM_RegWre(MEM_RegWre),
        .EX_PCadd4(EX_PCadd4),
        .MEM_PCadd4(MEM_PCadd4),
        .EX_BranchPC(EX_BranchPC),
        .MEM_BranchPC(MEM_BranchPC),
        .EX_Zero(EX_Zero),
        .MEM_Zero(MEM_Zero),
        .EX_Sign(EX_Sign),
        .MEM_Sign(MEM_Sign),
        .EX_DataIn(EX_DataIn),
        .MEM_DataIn(MEM_DataIn),
        .EX_ALUResult(EX_ALUResult),
        .MEM_ALUResult(MEM_ALUResult),
        .EX_WriteReg(EX_WriteReg),
        .MEM_WriteReg(MEM_WriteReg)
    );

    // ʱ���ź�����
    always begin
        #50 Clk = ~Clk;
    end

    // ��ʼ���ź�
    initial begin
        // ��ʼ��ʱ��
        Clk = 0;

        // ��ʼ�������ź�
        EX_MEM_Flush = 0;
        EX_MemWre = 1;
        EX_MemRead = 1;
        EX_BranchType = 2'b01;
        EX_DBDataSrc = 2;
        EX_RegWre = 1;
        EX_PCadd4=32'h12340000;
        EX_BranchPC = 32'h12345678;
        EX_Zero = 1;
        EX_Sign = 0;
        EX_DataIn = 32'hABC;
        EX_ALUResult = 32'hC0FFEE;
        EX_WriteReg = 5'b00001;

        // ���濪ʼ
        #100;

        // ���� flush �źţ�ģ���֧����
        EX_MEM_Flush = 1;
        #100;

        // ��� flush �źţ��ָ�����
        EX_MEM_Flush = 0;
        #100;

        // ֹͣ����
        $stop;
    end


endmodule
