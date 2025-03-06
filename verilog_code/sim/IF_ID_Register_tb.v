`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 14:47:49
// Design Name: 
// Module Name: IF_ID_Register_tb
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


module IF_ID_Register_tb( );

    //input 
    reg IF_ID_Flush,IF_ID_Wre;
    reg Clk;
    
    //output
    reg [31:0] IF_Instruction;
    reg [31:0] IF_PCadd4;
    
    wire [31:0] ID_Instruction;
    wire [31:0] ID_PCadd4;
    wire[5:0] Opcode;
    wire[4:0] rs,rt,rd,sa;
    wire[5:0] func;
    wire[15:0] Immediate;
    wire[25:0] targetAddress;
    
    IF_ID_Register if_id_register(
    .IF_ID_Flush(IF_ID_Flush),
    .IF_ID_Wre(IF_ID_Wre),
    .Clk(Clk),
    .IF_Instruction(IF_Instruction),
    .IF_PCadd4(IF_PCadd4),
    .ID_Instruction(ID_Instruction),
    .ID_PCadd4(ID_PCadd4),
    
    .Opcode(Opcode),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .sa(sa),
    .func(func),
    .Immediate(Immediate),
    .targetAddress(targetAddress)
    );
    
    initial begin
        //正常情况下：顺序执行
        IF_ID_Flush=0;
        IF_ID_Wre=1;
        
        Clk=1;
        IF_Instruction=32'd8;
        IF_PCadd4=32'd4;
        Clk=1;
        #50;
        
        Clk=0;
        #50;
        
        IF_Instruction=32'd12;
        IF_PCadd4=32'd8;
        Clk=1;
        #50;
        
        IF_ID_Flush=1;
        Clk=0;
        #50;
        
        //分支指令，要发生分支
        
        

        IF_Instruction=32'd16;
        IF_PCadd4=32'd8;
        Clk=1;
        #50;
        
        //继续正常顺序执行
        IF_ID_Flush=0;
        Clk=0;
        #50;
        
        
        IF_ID_Wre=1;
        
        Clk=1;
        IF_Instruction=32'd20;
        IF_PCadd4=32'd12;
        Clk=1;
        #50;
        
        Clk=0;
        #50;
        
        
        //load-use冲突，要阻塞
        IF_ID_Flush=0;
        IF_ID_Wre=0;//不写入
        
        Clk=1;
        IF_Instruction=32'd24;
        IF_PCadd4=32'd16;
        Clk=1;
        #50;
        
        Clk=0;
        //#50;
        
        //继续正常顺序执行
        IF_ID_Flush=0;
        IF_ID_Wre=1;
        
 
        IF_Instruction=32'd28;
        IF_PCadd4=32'd20;
        Clk=1;
        #50;
        
        Clk=0;
        #50;
        
        $stop;
    end
endmodule
