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
    //�����ź�
    reg Clk;
    reg PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit;
    reg Reset;
    reg[1:0] PCSrc;
    reg JumpPCSrc;
    
    //����ͨ·
    reg [31:0] ID_PCadd4;
    reg [25:0] ID_targetAddress;
    reg [31:0] ID_ReadData1;
    reg [31:0] MEM_BranchPC;


    //outputs
    wire [31:0] currAddress;
    wire [31:0] nextPCAddress;
    wire [31:0] IF_PCadd4;
    
    //����
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
    
    // ʱ���ź�����
    always begin
        #5 Clk = ~Clk;
    end
    
    initial begin
        //��ʼ��
        Clk = 0;
        PCWre_from_Control_Unit = 1;
        PCWre_from_Load_use_Detection_Unit=1;

        PCSrc = 0;//˳��ִ��
        ID_PCadd4=32'd4;
        ID_targetAddress=26'b10;
        MEM_BranchPC=32'd100;
        ID_ReadData1=32'h20;
        
        JumpPCSrc=1;
        
        Reset = 1;//����
        #10;
        
        //Test1��˳��ִ����һ��ָ��
        Reset = 0;//������
        PCSrc = 0;//˳��ִ��
        #10;
        
        //Test2����ָ֧�����ת
        PCSrc = 1;//��ָ֧�����ת
        #10;
        
        PCSrc = 0;//˳��ִ��
        #10;
        
        //Test3����תָ��j,jal
        PCSrc = 2;//��תָ��
        #10;
        
        PCSrc = 0;//˳��ִ��
        #10;
        
        //Test4����תָ��jr
        PCSrc = 2;//��תָ��
        JumpPCSrc=0;
        #10;
        
        PCSrc = 0;//˳��ִ��
        #10;
        
        PCSrc = 0;//˳��ִ��
        #10;

        //��Load_useð��
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
