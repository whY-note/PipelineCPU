`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 18:56:23
// Design Name: 
// Module Name: Program_Counter_tb
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


module Program_Counter_tb( );

    //inputs
    //控制信号
    reg Clk;
    reg PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit;
    reg Reset;
    reg[1:0] PCSrc;
    reg JumpPCSrc;
    
    //数据通路
    reg [31:0] ID_PCadd4;
    reg [25:0] ID_targetAddress;
    reg [31:0] ID_ReadData1;
    reg [31:0] MEM_BranchPC;


    //outputs
    wire [31:0] currAddress;
    wire [31:0] nextPCAddress;
    wire [31:0] IF_PCadd4;
    
    //例化
    Program_Counter pc(
    .Clk(Clk),
    .PCWre_from_Control_Unit(PCWre_from_Control_Unit),
    .PCWre_from_Load_use_Detection_Unit(PCWre_from_Load_use_Detection_Unit),
    .Reset(Reset),
    .PCSrc(PCSrc),
    .JumpPCSrc(JumpPCSrc),
    .currAddress(currAddress),
    .nextPCAddress(nextPCAddress),
    .ID_targetAddress(ID_targetAddress),
    .MEM_BranchPC(MEM_BranchPC),
    .ID_PCadd4(ID_PCadd4),
    .IF_PCadd4(IF_PCadd4),
    .ID_ReadData1(ID_ReadData1)
    );
    
    // 时钟信号生成
    always begin
        #5 Clk = ~Clk;
    end
    
    initial begin
        //初始化
        Clk = 0;
        PCWre_from_Control_Unit = 1;
        PCWre_from_Load_use_Detection_Unit=1;

        PCSrc = 0;//顺序执行
        ID_PCadd4=32'd4;
        ID_targetAddress=26'b10;
        MEM_BranchPC=32'd100;
        ID_ReadData1=32'h20;
        
        JumpPCSrc=1;
        
        Reset = 1;//置零
        #10;
        
        //Test1：顺序执行下一条指令
        Reset = 0;//不置零
        PCSrc = 0;//顺序执行
        #10;
        
        //Test2：分支指令的跳转
        PCSrc = 1;//分支指令的跳转
        #10;
        
        PCSrc = 0;//顺序执行
        #10;
        
        //Test3：跳转指令j,jal
        PCSrc = 2;//跳转指令
        #10;
        
        PCSrc = 0;//顺序执行
        #10;
        
        //Test4：跳转指令jr
        PCSrc = 2;//跳转指令
        JumpPCSrc=0;
        #10;
        
        PCSrc = 0;//顺序执行
        #10;
        
        PCSrc = 0;//顺序执行
        #10;

        //有Load_use冒险
        PCWre_from_Control_Unit=1;
        PCWre_from_Load_use_Detection_Unit=0;
        #10;

        //halt
        PCWre_from_Control_Unit=0;
        PCWre_from_Load_use_Detection_Unit=1;
        #10;
        $stop;
    end
endmodule
