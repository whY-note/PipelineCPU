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
    //�����ź�
    reg MemWre,
MemRead,Clk;
    //����ͨ·
    reg [31:0] DataAddress,DataIn;
    
    //output
    wire [31:0] DataOut;//�����ļ��е�outputһ����wire��
    
    DataMemory DMem(
    .MemWre(MemWre),
    .MemRead(MemRead),
    .Clk(Clk),
    .DataAddress(DataAddress),
    .DataIn(DataIn),
    .DataOut(DataOut)
    );
    
    initial begin //initial��ֻ�ܶ�reg�ͽ��и�ֵ�������wire�;ͻᱨ��
        
        //Test1:���� д����
         MemWre=1;
         MemRead=0;
         DataAddress=32'd8;
         DataIn=32'd1;
         Clk=1;
         #50;
         Clk=0;
         #50;
         
         //Test2:���� �����е�����
         MemWre=0;
         MemRead=1;
         DataAddress=32'd8;
         DataIn=32'd2;
         Clk=1;
         #50;
         Clk=0;
         #50;
         
         //Test3:���� ��δ�е�����
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

