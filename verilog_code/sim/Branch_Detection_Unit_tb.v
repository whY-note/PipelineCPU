`timescale 1ns / 1ps

module Branch_Detection_Unit_tb;

    // inputs
    reg [1:0] MEM_BranchType;
    reg MEM_Zero, MEM_Sign;
    
    //output
    wire Branch;

    // ʵ����������ģ��
    Branch_Detection_Unit uut (
        .MEM_BranchType(MEM_BranchType),
        .MEM_Zero(MEM_Zero),
        .MEM_Sign(MEM_Sign),
        .Branch(Branch)
    );


    initial begin

        // ��ʼ�������ź�
        MEM_BranchType = 2'b00; // Ĭ��״̬
        MEM_Zero = 0;
        MEM_Sign = 0;
        #10 
        // Test1: beqָ�MEM_Zero = 1����ȣ���Ӧ�÷�֧
        MEM_BranchType = 2'b01; MEM_Zero = 1;
        #10 

        // Test2: beq ָ�MEM_Zero = 0������ȣ�����Ӧ�÷�֧
        MEM_BranchType = 2'b01;  MEM_Zero = 0;
        #10 

        // Test3: bne ָ�MEM_Zero = 1����ȣ�����Ӧ�÷�֧
        MEM_BranchType = 2'b10; MEM_Zero = 1;
        #10

        // Test4: bne ָ�MEM_Zero = 0������ȣ���Ӧ�÷�֧
        MEM_BranchType = 2'b10;  MEM_Zero = 0;
        #10

        // Test5: bltz ָ�MEM_Sign = 1����������Ӧ�÷�֧
        MEM_BranchType = 2'b11; MEM_Sign = 1;
        #10

        // Test6: bltz ָ�MEM_Sign = 0���Ǹ���������Ӧ�÷�֧
        MEM_BranchType = 2'b11; MEM_Sign = 0;
        #10

        // Test7: �Ƿ�ָ֧�MEM_BranchType = 2'b00����Ӧ�÷�֧
        MEM_BranchType = 2'b00;
        #10

        $finish;
    end
endmodule
