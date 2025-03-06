`timescale 1ns / 1ps

module Control_Unit_tb;

    //inputs
    // �����ź�
    reg Branch,ControlSrc;
    
    // ����ͨ·�ź�
    reg [5:0] Opcode;
    reg [5:0] func;
    
    //outputs
    // IF�׶�
    wire PCWre;
    wire [1:0] PCSrc;
    wire JumpPCSrc;
    
    // EX�׶�
    wire RegDst;
    wire ALUSrcB;
    wire ExtSel;
    wire [3:0] ALUOp;
    
    // MEM�׶�
    wire [1:0] BranchType;
    wire MemWre;
    wire MemRead;
    
    // WB�׶�
    wire RegWre;
    wire [1:0] DBDataSrc;
    
    // �����֧����ת�������ź�
    wire IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush;
    
    // ʵ�������Ƶ�Ԫģ��
    Control_Unit uut (
        .Branch(Branch),
        .ControlSrc(ControlSrc),
        .Opcode(Opcode),
        .func(func),
        .PCWre(PCWre),
        .PCSrc(PCSrc),
        .JumpPCSrc(JumpPCSrc),
        .RegDst(RegDst),
        .ALUSrcB(ALUSrcB),
        .ExtSel(ExtSel),
        .ALUOp(ALUOp),
        .BranchType(BranchType),
        .MemWre(MemWre),
        .MemRead(MemRead),
        .RegWre(RegWre),
        .DBDataSrc(DBDataSrc),
        .IF_ID_Flush(IF_ID_Flush),
        .ID_EX_Flush(ID_EX_Flush),
        .EX_MEM_Flush(EX_MEM_Flush)
    );
    
    // �������
    initial begin
        // ��ʼ���ź�
        Branch = 0;
        ControlSrc=0;
        Opcode = 6'b000000;
        func = 6'b000000;
        #10;
        
        // Test for R-type instruction (e.g., add)
        Opcode = 6'b000000; func = 6'b100000; Branch = 0; // R-type (add)
        #10;
        
        // Test for jump (j)
        Opcode = 6'b000010; func = 6'b000000; Branch = 0; // j
        #10;
        //Test for jump and link (jal)
        Opcode = 6'b000011;func = 6'b000000; Branch = 0; //jal
        #10;
        // Test for jump register (jr)
        Opcode = 6'b000000; func = 6'b001000; Branch = 0; // jr
        #10;
        
        // Test for branch equal (beq)
        Opcode = 6'b000100; func = 6'b000000; Branch = 0; // beq
        #10;
        // Test for branch not equal (bne)
        Opcode = 6'b000101; func = 6'b000000; Branch = 0; // bne
        #10;
        // Test for branch if less than (bltz)
        Opcode = 6'b000001; func = 6'b000000; Branch = 0; // bltz
        #10
        
        // Test for load word (lw)
        Opcode = 6'b100011; func = 6'b000000; Branch = 0; // lw
        #10; 
        // Test for store word (sw)
        Opcode = 6'b101011; func = 6'b000000; Branch = 0; // sw
        #10;
        
        // Test for add immediate (addiu)
        Opcode = 6'b001001; func = 6'b000000; Branch = 0; // addiu
        #10;
        // Test for and immediate (andi)
        Opcode = 6'b001100; func = 6'b000000; Branch = 0; // andi
        #10;
        // Test for or immediate (ori)
        Opcode = 6'b001101; func = 6'b000000; Branch = 0; // ori
        #10;
        // Test for xor immediate (xori)
        Opcode = 6'b001110; func = 6'b000000; Branch = 0; // xori
        #10;
        // Test for set less than immediate (slti)
        Opcode = 6'b001010; func = 6'b000000; Branch = 0; // slti
        #10;
        
        // Test for halt
        Opcode = 6'b111111; func = 6'b000000; Branch = 0; // halt
        #10;
        
        //����Ҫ��֧�����
        Opcode = 6'b000000; func = 6'b100000;//����ָ��
        Branch=1;ControlSrc=0;
        #10;

        //����Load-use�����
        Opcode = 6'b000000; func = 6'b100000;//����ָ��
        Branch=0;ControlSrc=1;
        #10;
        $finish;
    end
    
endmodule