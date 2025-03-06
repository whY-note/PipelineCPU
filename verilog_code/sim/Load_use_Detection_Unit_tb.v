`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/17 21:12:25
// Design Name: 
// Module Name: Load_use_Detection_Unit_tb
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


module Load_use_Detection_Unit_tb(  );

    //input 
    reg EX_MemRead;
    reg [4:0] EX_rt,ID_rs,ID_rt;
    
    //output 
    wire PCWre,IF_ID_Wre,ControlSrc;
    
    //例化
    Load_use_Detection_Unit load_use_detection_unit(
    .EX_MemRead(EX_MemRead),
    .EX_rt(EX_rt),
    .ID_rs(ID_rs),
    .ID_rt(ID_rt),
    .PCWre(PCWre),
    .IF_ID_Wre(IF_ID_Wre),
    .ControlSrc(ControlSrc)
    );
    
    initial begin
    //Test1:load与下一指令无冲突
        EX_MemRead=1;
        EX_rt=5'd3;
        ID_rs=5'd4;
        ID_rt=5'd5;
        #50;
        
    //Test2:load与下一指令有冲突
        EX_MemRead=1;
        EX_rt=5'd4;
        ID_rs=5'd4;
        ID_rt=5'd5;
        #50;
        
    //Test3:不是load
        EX_MemRead=0;
        EX_rt=5'd4;
        ID_rs=5'd4;
        ID_rt=5'd5;
        #50;
        $stop;
    end

endmodule
