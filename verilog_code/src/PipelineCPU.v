`timescale 1ns / 1ps

module PipelineCPU(
    //�����ź�
    input wire Clk,
    input wire Reset,

    //����ͨ·
    output wire [31:0] PCAddress,//��ǰPC�ĵ�ַ
    output wire [31:0] nextPCAddress,//��һ��PC�ĵ�ַ
    
    output wire [4:0] EX_rs,//rs�Ĵ������
    output wire[31:0] TempDataA,//������·ת��������ݣ�����չʾ������
    
    output wire [4:0] EX_rt,//rt�Ĵ������
    output wire[31:0] TempDataB,//������·ת��������ݣ�����д��Data Memory�����ݣ���������չʾ������
    
    output wire [31:0] EX_ALUResult,//ALU��������λ��EX�׶�
    output wire [31:0] WB_WriteData //д��Ĵ����Ľ����λ��WB�׶�
    
    //����debug
    //output wire[31:0] regData31
    
);


/////////////////////////////
//�����ź�
//IF�׶�
wire [1:0] PCSrc;
wire PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit;
wire JumpPCSrc;

//������ID�׶�
//����ID�׶�
wire ControlSrc;
wire ExtSel;
//����EX�׶�
wire [1:0] ID_RegDst;
wire ID_ALUSrcB;
wire [3:0] ID_ALUOp;
//����MEM�׶�
wire [1:0] ID_BranchType;
wire ID_MemWre,ID_MemRead;
//����WB�׶�
wire [1:0] ID_DBDataSrc;
wire ID_RegWre;


//������EX�׶�
//����EX�׶�
wire ALUSrcA;
wire [3:0] ALUCtr;
wire [1:0] EX_RegDst;
wire EX_ALUSrcB;
wire [3:0] EX_ALUOp;
//����MEM�׶�
wire EX_MemWre,EX_MemRead;
wire [1:0] EX_BranchType;
//����WB�׶�
wire [1:0] EX_DBDataSrc;
wire EX_RegWre;


//������MEM�׶�
wire Branch;//MEM�׶β���
//����MEM�׶�
wire MEM_MemWre,MEM_MemRead;
wire [1:0] MEM_BranchType;
//����WB�׶�
wire [1:0] MEM_DBDataSrc;
wire MEM_RegWre;


//������WB�׶�
//����WB�׶�
wire [1:0] WB_DBDataSrc;
wire WB_RegWre;


//�����ͻ�Ŀ����ź�
wire [1:0] ForwardA,ForwardB;
wire IF_ID_Wre;
wire IF_ID_Flush;
wire ID_EX_Flush;
wire EX_MEM_Flush;


/////////////////////////////////
//����ͨ·
//IF�׶�
wire [31:0] IF_PCadd4;
wire [31:0] IF_Instruction;

//ID�׶�
wire [25:0] ID_targetAddress;
wire [31:0] ID_ReadData1,ID_ReadData2;
wire [31:0] ID_Instruction;//������

wire[5:0] Opcode;
wire[4:0] ID_rs,ID_rt,ID_rd,ID_sa;
wire[5:0] ID_func;
wire[15:0] Immediate;

wire [31:0] ID_PCadd4; //PC+4
wire [31:0] ID_Immediate32; //��չ���32λ��������

//EX�׶�
wire[5:0] EX_func;
wire[31:0] EX_PCadd4;
wire[31:0] EX_ReadData1,EX_ReadData2;
wire[4:0] EX_sa,EX_rd;
//EX_rs,EX_rt��Ϊ���������չʾ
wire[31:0] EX_Immediate32;
wire EX_Zero,EX_Sign;
//EX_ALUResult,����������Ϊ���
wire [31:0] EX_BranchPC;
wire[4:0] EX_WriteReg;
//TempDataA��TempDataB��Ϊ���������չʾ


//MEM�׶�
wire [31:0] MEM_PCadd4;
wire [31:0] MEM_BranchPC;
wire MEM_Zero,MEM_Sign;
wire [31:0] MEM_DataIn;
wire [31:0] MEM_ALUResult;
wire [31:0] MEM_DataFromMemory;
wire [4:0] MEM_WriteReg;

//WB�׶�
wire [31:0] WB_PCadd4;
wire [4:0] WB_WriteReg;
//WB_WriteData��Ϊ���������չʾ
wire [31:0] WB_DataFromALU;
wire [31:0] WB_DataFromMemory;


/////////////////////////////////////
//Ԫ������
Program_Counter u_Program_Counter(
    //input
    .Clk                                ( Clk                                ),
    .Reset                              ( Reset                              ),
    .PCWre_from_Control_Unit            ( PCWre_from_Control_Unit            ),
    .PCWre_from_Load_use_Detection_Unit ( PCWre_from_Load_use_Detection_Unit ),
    .PCSrc                              ( PCSrc                              ),
    .JumpPCSrc                          ( JumpPCSrc                          ),
    .ID_targetAddress                   ( ID_targetAddress                   ),
    .ID_PCadd4                          ( ID_PCadd4                          ),
    .ID_ReadData1                       ( ID_ReadData1                       ),
    .MEM_BranchPC                       ( MEM_BranchPC                       ),

    //output
    .IF_PCadd4                          ( IF_PCadd4                          ),
    .currAddress                        ( PCAddress                          ),
    .nextPCAddress                      ( nextPCAddress                      )
);


InstructionMemory u_InstructionMemory(
    //input
    .InstructionAddress ( PCAddress   ),
    //output
    .Instruction        ( IF_Instruction )
);

IF_ID_Register u_IF_ID_Register(
    //input
    .IF_ID_Flush    ( IF_ID_Flush    ),
    .IF_ID_Wre      ( IF_ID_Wre      ),
    .Clk            ( Clk            ),
    .IF_Instruction ( IF_Instruction ),
    .IF_PCadd4      ( IF_PCadd4      ),
    .Branch         ( Branch         ),
    
    //output
    .ID_Instruction ( ID_Instruction ),
    .Opcode         ( Opcode         ),
    .rs             ( ID_rs             ),
    .rt             ( ID_rt             ),
    .rd             ( ID_rd             ),
    .sa             ( ID_sa             ),
    .func           ( ID_func           ),
    .Immediate      ( Immediate      ),
    .targetAddress  ( ID_targetAddress  ),
    .ID_PCadd4      ( ID_PCadd4      )
);

RegisterFile u_RegisterFile(
    //input
    .Clk       ( Clk       ),
    .RegWre    ( WB_RegWre    ),
    .rs        ( ID_rs        ),
    .rt        ( ID_rt        ),
    .WriteReg  ( WB_WriteReg  ),
    .WriteData ( WB_WriteData ),

    //output
    .ReadData1 ( ID_ReadData1 ),
    .ReadData2 ( ID_ReadData2 )
    
    //����debug
    //.regData31 ( regData31    )
);

SignZeroExtend u_SignZeroExtend(
    //input
    .ExtSel    ( ExtSel    ),
    .Immediate ( Immediate ),

    //output
    .Out       ( ID_Immediate32 )
);

Control_Unit u_Control_Unit(
    //input
    .Branch       ( Branch       ),
    .ControlSrc   ( ControlSrc   ),
    .Opcode       ( Opcode       ),
    .func         ( ID_func      ),

    //output
    .PCWre        ( PCWre_from_Control_Unit ),
    .PCSrc        ( PCSrc        ),
    .JumpPCSrc    ( JumpPCSrc    ),
    .RegDst       ( ID_RegDst       ),
    .ALUSrcB      ( ID_ALUSrcB      ),
    .ExtSel       ( ExtSel       ),
    .ALUOp        ( ID_ALUOp        ),
    .BranchType   ( ID_BranchType   ),
    .MemWre       ( ID_MemWre       ),
    .MemRead      ( ID_MemRead      ),
    .RegWre       ( ID_RegWre       ),
    .DBDataSrc    ( ID_DBDataSrc    ),

    .IF_ID_Flush  ( IF_ID_Flush  ),
    .ID_EX_Flush  ( ID_EX_Flush  ),
    .EX_MEM_Flush ( EX_MEM_Flush )  
);

ID_EX_Register u_ID_EX_Register(
    .Clk            ( Clk            ),
    .ID_EX_Flush    ( ID_EX_Flush    ),
    .ID_ALUSrcB     ( ID_ALUSrcB     ),
    .EX_ALUSrcB     ( EX_ALUSrcB     ),
    .ID_ALUOp       ( ID_ALUOp       ),
    .EX_ALUOp       ( EX_ALUOp       ),
    .ID_RegDst      ( ID_RegDst      ),
    .EX_RegDst      ( EX_RegDst      ),
    .ID_MemWre      ( ID_MemWre      ),
    .EX_MemWre      ( EX_MemWre      ),
    .ID_MemRead     ( ID_MemRead     ),
    .EX_MemRead     ( EX_MemRead     ),
    .ID_BranchType  ( ID_BranchType  ),
    .EX_BranchType  ( EX_BranchType  ),
    .ID_DBDataSrc   ( ID_DBDataSrc   ),
    .EX_DBDataSrc   ( EX_DBDataSrc   ),
    .ID_RegWre      ( ID_RegWre      ),
    .EX_RegWre      ( EX_RegWre      ),
    .ID_PCadd4      ( ID_PCadd4      ),
    .EX_PCadd4      ( EX_PCadd4      ),
    .ID_ReadData1   ( ID_ReadData1   ),
    .ID_ReadData2   ( ID_ReadData2   ),
    .EX_ReadData1   ( EX_ReadData1   ),
    .EX_ReadData2   ( EX_ReadData2   ),
    .ID_sa          ( ID_sa          ),
    .ID_rs          ( ID_rs          ),
    .ID_rt          ( ID_rt          ),
    .ID_rd          ( ID_rd          ),
    .EX_sa          ( EX_sa          ),
    .EX_rs          ( EX_rs          ),
    .EX_rt          ( EX_rt          ),
    .EX_rd          ( EX_rd          ),
    .ID_Immediate32 ( ID_Immediate32 ),
    .EX_Immediate32 ( EX_Immediate32 ),
    .ID_func        ( ID_func        ),
    .EX_func        ( EX_func        )
);

ALU_Control u_ALU_Control(
    //input
    .func    ( EX_func    ),
    .ALUOp   ( EX_ALUOp   ),

    //output
    .ALUSrcA ( ALUSrcA ),
    .ALUCtr  ( ALUCtr  )
);

ALU u_ALU(
    //input
    .ALUCtr        ( ALUCtr        ),
    .ALUSrcA       ( ALUSrcA       ),
    .ALUSrcB       ( EX_ALUSrcB    ),
    .ForwardA      ( ForwardA      ),
    .ForwardB      ( ForwardB      ),
    .ReadData1     ( EX_ReadData1  ),
    .ReadData2     ( EX_ReadData2  ),
    .sa            ( EX_sa         ),
    .ExtData       ( EX_Immediate32),
    .WB_WriteData  ( WB_WriteData  ),
    .MEM_ALUResult ( MEM_ALUResult ),

    //output
    .Zero          ( EX_Zero       ),
    .Sign          ( EX_Sign       ),
    .EX_ALUResult  ( EX_ALUResult  ),
    .TempDataA     ( TempDataA     ),//����չʾ������
    .TempDataB     ( TempDataB     ) //����չʾ������
);

Adder_BranchPC u_Adder_BranchPC(
    //input
    .EX_PCadd4      ( EX_PCadd4      ),
    .EX_Immediate32 ( EX_Immediate32 ),

    //output
    .EX_BranchPC    ( EX_BranchPC    )
);

RegDst_Mux u_RegDst_Mux(
    //input
    .RegDst ( EX_RegDst ),
    .rt     ( EX_rt     ),
    .rd     ( EX_rd     ),

    //output
    .WriteReg  ( EX_WriteReg  )
);

Forwarding_Unit u_Forwarding_Unit(
    //input
    .MEM_RegWre   ( MEM_RegWre   ),
    .WB_RegWre    ( WB_RegWre    ),
    .EX_rs        ( EX_rs        ),
    .EX_rt        ( EX_rt        ),
    .MEM_WriteReg ( MEM_WriteReg ),
    .WB_WriteReg  ( WB_WriteReg  ),

    //output
    .ForwardA     ( ForwardA     ),
    .ForwardB     ( ForwardB     )
);

EX_MEM_Register u_EX_MEM_Register(
    .Clk            ( Clk            ),
    .EX_MEM_Flush   ( EX_MEM_Flush   ),
    .EX_MemWre      ( EX_MemWre      ),
    .MEM_MemWre     ( MEM_MemWre     ),
    .EX_MemRead     ( EX_MemRead     ),
    .MEM_MemRead    ( MEM_MemRead    ),
    .EX_BranchType  ( EX_BranchType  ),
    .MEM_BranchType ( MEM_BranchType ),
    .EX_DBDataSrc   ( EX_DBDataSrc   ),
    .MEM_DBDataSrc  ( MEM_DBDataSrc  ),
    .EX_RegWre      ( EX_RegWre      ),
    .MEM_RegWre     ( MEM_RegWre     ),
    .EX_PCadd4      ( EX_PCadd4      ),
    .MEM_PCadd4     ( MEM_PCadd4     ),
    .EX_BranchPC    ( EX_BranchPC    ),
    .MEM_BranchPC   ( MEM_BranchPC   ),
    .EX_Zero        ( EX_Zero        ),
    .EX_Sign        ( EX_Sign        ),
    .MEM_Zero       ( MEM_Zero       ),
    .MEM_Sign       ( MEM_Sign       ),
    .EX_DataIn      ( TempDataB      ),
    .MEM_DataIn     ( MEM_DataIn     ),
    .EX_ALUResult   ( EX_ALUResult   ),
    .MEM_ALUResult  ( MEM_ALUResult  ),
    .EX_WriteReg    ( EX_WriteReg    ),
    .MEM_WriteReg   ( MEM_WriteReg   )
);



Branch_Detection_Unit u_Branch_Detection_Unit(
    //input
    .MEM_BranchType ( MEM_BranchType ),
    .MEM_Zero       ( MEM_Zero       ),
    .MEM_Sign       ( MEM_Sign       ),

    //output
    .Branch         ( Branch         )
);

DataMemory u_DataMemory(
    //input
    .MemWre      ( MEM_MemWre  ),
    .MemRead     ( MEM_MemRead ),
    .Clk         ( Clk         ),
    .DataAddress ( MEM_ALUResult ),
    .DataIn      ( MEM_DataIn  ),

    //output
    .DataOut     ( MEM_DataFromMemory )
);

MEM_WB_Register u_MEM_WB_Register(
    .Clk                ( Clk                ),
    .MEM_DBDataSrc      ( MEM_DBDataSrc      ),
    .WB_DBDataSrc       ( WB_DBDataSrc       ),
    .MEM_RegWre         ( MEM_RegWre         ),
    .WB_RegWre          ( WB_RegWre          ),
    .MEM_PCadd4         ( MEM_PCadd4         ),
    .WB_PCadd4          ( WB_PCadd4          ),
    .MEM_DataFromMemory ( MEM_DataFromMemory ),
    .WB_DataFromMemory  ( WB_DataFromMemory  ),
    .MEM_DataFromALU    ( MEM_ALUResult      ),
    .WB_DataFromALU     ( WB_DataFromALU     ),
    .MEM_WriteReg       ( MEM_WriteReg       ),
    .WB_WriteReg        ( WB_WriteReg        )
);

WB_Mux u_WB_Mux(
    //input
    .DBDataSrc   ( WB_DBDataSrc ),
    .DataFromALU ( WB_DataFromALU  ),
    .DataFromMem ( WB_DataFromMemory  ),
    .WB_PCadd4   ( WB_PCadd4    ),

    //output
    .WriteData   ( WB_WriteData )
);


Load_use_Detection_Unit u_Load_use_Detection_Unit(
    //input
    .EX_MemRead ( EX_MemRead ),
    .EX_rt      ( EX_rt      ),
    .ID_rs      ( ID_rs      ),
    .ID_rt      ( ID_rt      ),
    .Reset      ( Reset      ),

    //output
    .PCWre      ( PCWre_from_Load_use_Detection_Unit      ),
    .IF_ID_Wre  ( IF_ID_Wre  ),
    .ControlSrc ( ControlSrc )
);
endmodule