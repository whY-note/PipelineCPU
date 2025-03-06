`timescale 1ns / 1ps

module Control_Unit(
    //控制信号
    
    input wire Branch,
    input wire ControlSrc,
    
    //IF阶段
    output reg PCWre,
    output reg [1:0] PCSrc,
    output reg JumpPCSrc,

    //ID阶段
    output reg ExtSel,
    
    //EX阶段
    output reg [1:0] RegDst,
    output reg ALUSrcB,
    output reg [3:0] ALUOp,
    
    //MEM阶段
    output reg[1:0] BranchType,
    output reg MemWre,
    output reg MemRead,
    
    //WB阶段
    output reg RegWre,
    output reg [1:0] DBDataSrc,
    
    //处理分支，跳转的清零信号
    output reg IF_ID_Flush,ID_EX_Flush,EX_MEM_Flush,
   
    //数据通路
    input wire [5:0] Opcode,
    input wire [5:0] func//专门为jr而设
    );
    
    initial begin
        IF_ID_Flush=0;
        PCSrc=0;
        PCWre=1;
    end
    
    
    
    
    always @(*) begin
        //默认不分支，全为0
        IF_ID_Flush=0;
        ID_EX_Flush=0;
        EX_MEM_Flush=0;
        
        //处理分支
        //如果要分支，则IF_ID_Flush,ID_EX_Flush,EX_MEM_Flush 均为1，用于清零
        if(Branch==1) begin
            PCSrc=2'b01;//要分支，所以 PCSrc=2'b01
            PCWre=1;
            IF_ID_Flush=1;
            ID_EX_Flush=1;
            EX_MEM_Flush=1;
        end
        
//        //如果要跳转
//        if(Jump==1) begin
//            PCSrc=2'b10;//要跳转
//            PCWre=1;
//            IF_ID_Flush=1;
//            ID_EX_Flush=0;
//            EX_MEM_Flush=0;
//        end

        //如果出现Load-use冲突
        else if(ControlSrc==1) begin
            RegWre=0;//不写寄存器
            MemWre=0;//不写存储器
        end

        //其他情况（包含跳转在内）：
        else begin
        case(Opcode)
            6'b000000://R型或jr
            
                 //jr
                if(func==6'b001000)
                begin
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=0;//从寄存器rs取来
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;//默认0，任意均可
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b0000;//默认，任意均可
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，任意均可
                    
                    //IF_ID_Register中的数据清零
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
                
                //R型指令
                else 
                begin
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1，任意均可
                    
                    //EX
                    RegDst=1;//rd
                    ALUSrcB=0;
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b1000;//R型指令
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                    
                end
            6'b001001://addiu
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001100://andi
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0010;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001101://ori
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0011;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001110://xori
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0111;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001010://slti
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0110;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b101011://sw
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=1;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;//不写寄存器
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b100011://lw
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=1;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=1;//从Data Memory写回
                end
            6'b000100://beq
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//假设顺序执行，所以 PCSrc=2'b00
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//减法
                    
                    //MEM阶段
                    BranchType=2'b01;//beq
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b000101://bne
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//假设顺序执行，所以 PCSrc=2'b00
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//减法
                    
                    //MEM阶段
                    BranchType=2'b10;//bne
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b000001://bltz
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//假设顺序执行，所以 PCSrc=2'b00
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//减法
                    
                    //MEM阶段
                    BranchType=2'b11;//bltz
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b000010://j
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;//默认0，任意均可
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b0000;//默认，任意均可
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                    
                    //IF_ID_Register中的数据清零
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
            6'b000011://jal
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=2'b10;//写回$31寄存器
                    ALUSrcB=0;//默认0，任意均可
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b0000;//默认，任意均可
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1; //写回$31寄存器
                    DBDataSrc=2;//写回的数据是PC+4
                    
                    //IF_ID_Register中的数据清零
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
