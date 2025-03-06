`timescale 1ns / 1ps

module Control_Unit(
    //�����ź�
    
    input wire Branch,
    input wire ControlSrc,
    
    //IF�׶�
    output reg PCWre,
    output reg [1:0] PCSrc,
    output reg JumpPCSrc,

    //ID�׶�
    output reg ExtSel,
    
    //EX�׶�
    output reg [1:0] RegDst,
    output reg ALUSrcB,
    output reg [3:0] ALUOp,
    
    //MEM�׶�
    output reg[1:0] BranchType,
    output reg MemWre,
    output reg MemRead,
    
    //WB�׶�
    output reg RegWre,
    output reg [1:0] DBDataSrc,
    
    //�����֧����ת�������ź�
    output reg IF_ID_Flush,ID_EX_Flush,EX_MEM_Flush,
   
    //����ͨ·
    input wire [5:0] Opcode,
    input wire [5:0] func//ר��Ϊjr����
    );
    
    initial begin
        IF_ID_Flush=0;
        PCSrc=0;
        PCWre=1;
    end
    
    
    
    
    always @(*) begin
        //Ĭ�ϲ���֧��ȫΪ0
        IF_ID_Flush=0;
        ID_EX_Flush=0;
        EX_MEM_Flush=0;
        
        //�����֧
        //���Ҫ��֧����IF_ID_Flush,ID_EX_Flush,EX_MEM_Flush ��Ϊ1����������
        if(Branch==1) begin
            PCSrc=2'b01;//Ҫ��֧������ PCSrc=2'b01
            PCWre=1;
            IF_ID_Flush=1;
            ID_EX_Flush=1;
            EX_MEM_Flush=1;
        end
        
//        //���Ҫ��ת
//        if(Jump==1) begin
//            PCSrc=2'b10;//Ҫ��ת
//            PCWre=1;
//            IF_ID_Flush=1;
//            ID_EX_Flush=0;
//            EX_MEM_Flush=0;
//        end

        //�������Load-use��ͻ
        else if(ControlSrc==1) begin
            RegWre=0;//��д�Ĵ���
            MemWre=0;//��д�洢��
        end

        //���������������ת���ڣ���
        else begin
        case(Opcode)
            6'b000000://R�ͻ�jr
            
                 //jr
                if(func==6'b001000)
                begin
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=0;//�ӼĴ���rsȡ��
                    
                    //EX
                    RegDst=0;//Ĭ��0���������
                    ALUSrcB=0;//Ĭ��0���������
                    ExtSel=1;//Ĭ��1���������
                    ALUOp=4'b0000;//Ĭ�ϣ��������
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=0;
                    DBDataSrc=0;//Ĭ��0���������
                    
                    //IF_ID_Register�е���������
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
                
                //R��ָ��
                else 
                begin
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1���������
                    
                    //EX
                    RegDst=1;//rd
                    ALUSrcB=0;
                    ExtSel=1;//Ĭ��1���������
                    ALUOp=4'b1000;//R��ָ��
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=1;
                    DBDataSrc=0;//д��ALU������
                    
                end
            6'b001001://addiu
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=1;
                    DBDataSrc=0;//д��ALU������
                end
            6'b001100://andi
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0010;
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=1;
                    DBDataSrc=0;//д��ALU������
                end
            6'b001101://ori
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0011;
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=1;
                    DBDataSrc=0;//д��ALU������
                end
            6'b001110://xori
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0111;
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=1;
                    DBDataSrc=0;//д��ALU������
                end
            6'b001010://slti
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0110;
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=1;
                    DBDataSrc=0;//д��ALU������
                end
            6'b101011://sw
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=1;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=0;//��д�Ĵ���
                    DBDataSrc=0;//Ĭ��0��ʵ��������Կ�
                end
            6'b100011://lw
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=1;
                    
                    //WB�׶�
                    RegWre=1;
                    DBDataSrc=1;//��Data Memoryд��
                end
            6'b000100://beq
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//����˳��ִ�У����� PCSrc=2'b00
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//Ĭ��0���������
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//����
                    
                    //MEM�׶�
                    BranchType=2'b01;//beq
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=0;
                    DBDataSrc=0;//Ĭ��0��ʵ��������Կ�
                end
            6'b000101://bne
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//����˳��ִ�У����� PCSrc=2'b00
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//Ĭ��0���������
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//����
                    
                    //MEM�׶�
                    BranchType=2'b10;//bne
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=0;
                    DBDataSrc=0;//Ĭ��0��ʵ��������Կ�
                end
            6'b000001://bltz
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//����˳��ִ�У����� PCSrc=2'b00
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//Ĭ��0���������
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//����
                    
                    //MEM�׶�
                    BranchType=2'b11;//bltz
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=0;
                    DBDataSrc=0;//Ĭ��0��ʵ��������Կ�
                end
            6'b000010://j
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=0;//Ĭ��0���������
                    ALUSrcB=0;//Ĭ��0���������
                    ExtSel=1;//Ĭ��1���������
                    ALUOp=4'b0000;//Ĭ�ϣ��������
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=0;
                    DBDataSrc=0;//Ĭ��0��ʵ��������Կ�
                    
                    //IF_ID_Register�е���������
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
            6'b000011://jal
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=1;//Ĭ��1
                    
                    //EX
                    RegDst=2'b10;//д��$31�Ĵ���
                    ALUSrcB=0;//Ĭ��0���������
                    ExtSel=1;//Ĭ��1���������
                    ALUOp=4'b0000;//Ĭ�ϣ��������
                    
                    //MEM�׶�
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB�׶�
                    RegWre=1; //д��$31�Ĵ���
                    DBDataSrc=2;//д�ص�������PC+4
                    
                    //IF_ID_Register�е���������
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
            6'b111111://halt
                begin
                    //IF
                    PCWre=0;
                    PCSrc=2'b00;
                end
        endcase

        
        end
    end
endmodule
