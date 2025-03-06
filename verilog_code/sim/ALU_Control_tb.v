`timescale 1ns / 1ps

module ALU_Control_tb();

    // Inputs
    reg [5:0] func;         // Function code (from the instruction)
    reg [3:0] ALUOp;        // ALU operation code

    // Outputs
    wire ALUSrcA;           // ALUSrcA control signal
    wire [3:0] ALUCtr;      // ALU control signals for the operation

    // Instantiate the ALU_Control module
    ALU_Control alu_control (
        .func(func),
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcA),
        .ALUCtr(ALUCtr)
    );

    // Test stimulus
    initial begin
        // Test R-type instructions (ALUOp = 4'b1000)
        ALUOp = 4'b1000; func = 6'b100000; // ADD
        #10 
        ALUOp = 4'b1000; func = 6'b100010; // SUB
        #10 
        ALUOp = 4'b1000; func = 6'b100100; // AND
        #10 
        ALUOp = 4'b1000; func = 6'b100101; // OR
        #10 
        ALUOp = 4'b1000; func = 6'b000000; // LEFT SHIFT
        #10 
        ALUOp = 4'b1000; func = 6'b100110; // XOR
        #10 
        ALUOp = 4'b1000; func = 6'b101011; // SLTU (unsigned compare)
        #10 
        ALUOp = 4'b1000; func = 6'b101010; // SLT (signed compare)
        #10
        
        
        // Test I-type instructions (other ALUOp values)
        
        // Test ADDI (ALUOp = 4'b0000)
        ALUOp = 4'b0000; func = 6'b000000; // ADDI (any func code)
        #10
        // Test BEQ (ALUOp = 4'b0001)
        ALUOp = 4'b0001; func = 6'b000000; // BEQ (any func code)
        #10
        // Test ANDI (ALUOp = 4'b0010)
        ALUOp = 4'b0010; func = 6'b000000; // ANDI (any func code)
        #10
        // Test ORI (ALUOp = 4'b0011)
        ALUOp = 4'b0011; func = 6'b000000; // ORI (any func code)
        #10
        // Test SLTIU (ALUOp = 4'b0101)
        ALUOp = 4'b0101; func = 6'b000000; // SLTIU (any func code)
        #10
        // Test SLTI (ALUOp = 4'b0110)
        ALUOp = 4'b0110; func = 6'b000000; // SLTI (any func code)
        #10
        // Test XORI (ALUOp = 4'b0111)
        ALUOp = 4'b0111; func = 6'b000000; // XORI (any func code)
        #10
        
        // End of test
        $finish;
    end
    
endmodule
