`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 17:54:31
// Design Name: 
// Module Name: DataMemory_tb
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


module DataMemory_tb(    );
    //inputs
    //控制信号
    reg MemWre,
MemRead,Clk;
    //数据通路
    reg [31:0] DataAddress,DataIn;
    
    //output
    wire [31:0] DataOut;//仿真文件中的output一定是wire型
    
    DataMemory DMem(
    .MemWre(MemWre),
    .MemRead(MemRead),
    .Clk(Clk),
    .DataAddress(DataAddress),
    .DataIn(DataIn),
    .DataOut(DataOut)
    );
    
    initial begin //initial中只能对reg型进行赋值，如果对wire型就会报错
        
        //Test1:测试 写数据
         MemWre=1;
         MemRead=0;
         DataAddress=32'd8;
         DataIn=32'd1;
         Clk=1;
         #50;
         Clk=0;
         #50;
         
         //Test2:测试 读已有的数据
         MemWre=0;
         MemRead=1;
         DataAddress=32'd8;
         DataIn=32'd2;
         Clk=1;
         #50;
         Clk=0;
         #50;
         
         //Test3:测试 读未有的数据
         MemWre=0;
         MemRead=1;
         DataAddress=32'd1;
         DataIn=32'd3;
         Clk=1;
         #50;
         Clk=0;
         #50;
         $stop;

    end
endmodule

