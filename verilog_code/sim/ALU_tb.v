`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg [3:0] ALUCtr;
    reg ALUSrcA, ALUSrcB;
    reg [1:0] ForwardA, ForwardB;
    reg [31:0] ReadData1, ReadData2;
    reg [4:0] sa;
    reg [31:0] ExtData;
    reg [31:0] WB_WriteData, MEM_ALUResult;

    // Outputs
    wire Zero;
    wire Sign;
    wire [31:0] EX_ALUResult;
    wire [31:0] TempDataB;

    // Instantiate the ALU module
    ALU uut (
        .ALUCtr(ALUCtr),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .sa(sa),
        .ExtData(ExtData),
        .WB_WriteData(WB_WriteData),
        .MEM_ALUResult(MEM_ALUResult),
        .Zero(Zero),
        .Sign(Sign),
        .EX_ALUResult(EX_ALUResult),
        .TempDataB(TempDataB)
    );

    // Test stimulus
    initial begin
        // Initialize Inputs
        ALUCtr = 4'b0000;  // ADD operation
        ALUSrcA = 0;
        ALUSrcB = 0;
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        ReadData1 = 32'd00;
        ReadData2 = 32'd0;
        sa = 5'b0;
        ExtData = 32'd0;
        WB_WriteData = 32'd0;
        MEM_ALUResult = 32'd0;
        #10

        //正常执行
        // Test ADD operation
        ALUSrcA = 0; ALUSrcB = 0; ForwardA = 2'b00; ForwardB = 2'b00; ReadData1 = 32'd10; ReadData2 = 32'd5;
        ALUCtr = 4'b0000; // ADD
        #10 
        
        //Test ADDI operation
        ALUCtr = 4'b0000; // ADD
        ALUSrcA = 0; ALUSrcB = 1;  ReadData1 = 32'd10; ReadData2 = 32'd5; ExtData=32'd8;
        #10
        
        // Test SUB operation
        ALUCtr = 4'b0001; // SUB
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'd15; ReadData2 = 32'd10;
        #10 
        
        // Test AND operation
        ALUCtr = 4'b0010; // AND
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hF0F0F0F0; ReadData2 = 32'h0F0F0F0F;
        #10 
        
        // Test OR operation
        ALUCtr = 4'b0011; // OR
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hFFFFF0F0; ReadData2 = 32'h0F0F0F0F;
        #10 
        
        // Test shift left operation (<<)
        ALUCtr = 4'b0100; // Shift left
        ALUSrcA = 1; ALUSrcB = 0;
        sa=5'd2; ReadData2 = 32'd8;
        #10 
        
        // Test unsigned comparison
        ALUCtr = 4'b0101; // Unsigned comparison
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hffffffff; ReadData2 = 32'd10;
        #10 
        
        // Test signed comparison
        ALUCtr = 4'b0110; // Signed comparison
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hffffffff; ReadData2 = 32'd10;
        #10 
        
        // Test XOR operation
        ALUCtr = 4'b0111; // XOR
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hFFFFF0F0; ReadData2 = 32'h0F0F0F0F;
        #10 
        
        
        //需要用旁路转发(简便起见：只用ADD来测试）
        // Test Forward
        ALUCtr = 4'b0000; // OR
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'h1; ReadData2 = 32'h2;
        WB_WriteData = 32'd10;
        MEM_ALUResult = 32'd20;
        
        //单个数据需要转发
        ForwardA = 2'b01; 
        ForwardB = 2'b00;
        #10 
        
        ForwardA = 2'b00;
        ForwardB = 2'b01; 
        #10
        
        ForwardA = 2'b10;
        ForwardB = 2'b00;
        #10 
        
        ForwardA = 2'b00;
        ForwardB = 2'b10; 
        #10 
        
        
        //2个数据都要转发
        
        //都转发自WB
        ForwardA = 2'b01;
        ForwardB = 2'b01; 
        #10 
        
        //都转发自MEM
        ForwardA = 2'b10;
        ForwardB = 2'b10; 
        #10 
        
        //A转发自MEM，B转发自WB
        ForwardA = 2'b10;
        ForwardB = 2'b01; 
        #10 
        
        //A转发自WB，B转发自MEM
        ForwardA = 2'b01;
        ForwardB = 2'b10; 
        #10 
        
        // Finish the simulation
        $finish;
    end
    
   

endmodule
