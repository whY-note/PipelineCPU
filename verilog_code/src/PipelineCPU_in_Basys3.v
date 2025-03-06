`timescale 1ns / 1ps

module PipelineCPU_in_Basys3(

    input CLKButton,
    input BasysCLK, //Basys自身的时钟周期
    input RST_Button, //外部复位信号
    input [1:0] SW_in,

    output [7:0] SegOut,
    output [3:0] Bits
);

//CPU
wire [4:0] RsAddr, RtAddr;
wire [31:0] RsData, RtData;
wire [31:0] ALUResult;
wire [31:0] DBData;
wire [31:0] curPCAddress, nextPCAddress;

wire CPUCLK;
wire reset;//内部复位信号

//用于debug
//wire[31:0] regData31;

PipelineCPU CPU(
    //控制信号
    .Clk(CPUCLK),
    .Reset(reset),
    
    //数据通路
    .EX_rs(RsAddr),
    .EX_rt(RtAddr),
    .TempDataA(RsData),
    .TempDataB(RtData),
    
    .PCAddress(curPCAddress),
    .nextPCAddress(nextPCAddress),
    .EX_ALUResult(ALUResult),
    .WB_WriteData(DBData)
    
    //用于debug
   // .regData31(regData31)
);

//CLK_slow
wire Div_CLK;
CLK_slow clk_slow(
    .CLK_100mhz(BasysCLK),
    .CLK_slow(Div_CLK)
);

//Display_7Seg
wire [3:0] SegIn;

Display_7SegLED display_led(
    .display_data(SegIn),
    .dispcode(SegOut)
);

//Display_select
wire [15:0] display_data;
Select select(
    .In1({curPCAddress[7:0], nextPCAddress[7:0]}),
    .In2({3'b000, RsAddr[4:0], RsData[7:0]}),
    .In3({3'b000, RtAddr[4:0], RtData[7:0]}),
    .In4({ALUResult[7:0], DBData[7:0]}),
    
    //用于debug
    //.In4({ALUResult[7:0], regData31[7:0]}),

    .SelectCode(SW_in),
    .DataOut(display_data)
);

//Display_transfer
Transfer tansfer(
    .CLK(Div_CLK),
    .In(display_data),

    .Out(SegIn),
    .Bit(Bits)
);

//keyboard
Keyboard_CLK keyboard(
    .Button(CLKButton),
    .BasysCLK(BasysCLK),
    .CPUCLK(CPUCLK)
);

IBUFG RST_Button_IBUF (
      .O(reset), // 1-bit output: Clock output
      .I(RST_Button)  // 1-bit input: Clock input
   );
endmodule