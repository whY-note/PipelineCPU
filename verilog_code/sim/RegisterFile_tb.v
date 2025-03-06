`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 17:35:18
// Design Name: 
// Module Name: RegisterFile_tb
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


module RegisterFile_tb(

    );
    //input 
    reg Clk,RegWre;
    
    reg[4:0] rs,rt,WriteReg;
    reg[31:0] WriteData;
    
    //output 
    wire[31:0] ReadData1,ReadData2;
    
    //Àý»¯
    RegisterFile RF(
    .Clk(Clk),
    .RegWre(RegWre),
    .rs(rs),
    .rt(rt),
    .WriteData(WriteData),
    .WriteReg(WriteReg),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
    );
    
    initial begin
   
    //test1:²»Ð´
    Clk=1;
    RegWre=0;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd1;
    WriteReg=5'd1;
    #50;
    
    Clk=0;
    #50;
    
    //test2:Ð´
    Clk=1;
    RegWre=1;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd2;
    WriteReg=5'd1;
    #50;
    
    Clk=0;
    #50;
    
    //test3:²»Ð´
    Clk=1;
    RegWre=0;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd3;
    WriteReg=5'd2;
    #50;
    
    Clk=0;
    #50;
    
    //test4:Ð´
    Clk=1;
    RegWre=1;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd16;
    WriteReg=5'd2;
    #50;
    
    Clk=0;
    #50;
    
    //test5:Ð´
    Clk=1;
    RegWre=1;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd3;
    WriteReg=5'd2;
    #50;
    
    Clk=0;
    #50;
    
    $stop;
    
    
    end
endmodule
