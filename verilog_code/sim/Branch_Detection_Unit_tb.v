`timescale 1ns / 1ps

module Branch_Detection_Unit_tb;

    // inputs
    reg [1:0] MEM_BranchType;
    reg MEM_Zero, MEM_Sign;
    
    //output
    wire Branch;

    // 实例化被测试模块
    Branch_Detection_Unit uut (
        .MEM_BranchType(MEM_BranchType),
        .MEM_Zero(MEM_Zero),
        .MEM_Sign(MEM_Sign),
        .Branch(Branch)
    );


    initial begin

        // 初始化输入信号
        MEM_BranchType = 2'b00; // 默认状态
        MEM_Zero = 0;
        MEM_Sign = 0;
        #10 
        // Test1: beq指令，MEM_Zero = 1（相等），应该分支
        MEM_BranchType = 2'b01; MEM_Zero = 1;
        #10 

        // Test2: beq 指令，MEM_Zero = 0（不相等），不应该分支
        MEM_BranchType = 2'b01;  MEM_Zero = 0;
        #10 

        // Test3: bne 指令，MEM_Zero = 1（相等），不应该分支
        MEM_BranchType = 2'b10; MEM_Zero = 1;
        #10

        // Test4: bne 指令，MEM_Zero = 0（不相等），应该分支
        MEM_BranchType = 2'b10;  MEM_Zero = 0;
        #10

        // Test5: bltz 指令，MEM_Sign = 1（负数），应该分支
        MEM_BranchType = 2'b11; MEM_Sign = 1;
        #10

        // Test6: bltz 指令，MEM_Sign = 0（非负数），不应该分支
        MEM_BranchType = 2'b11; MEM_Sign = 0;
        #10

        // Test7: 非分支指令，MEM_BranchType = 2'b00，不应该分支
        MEM_BranchType = 2'b00;
        #10

        $finish;
    end
endmodule
