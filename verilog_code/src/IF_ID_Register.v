`timescale 1ns / 1ps

module IF_ID_Register(
    //控制信号
    input wire IF_ID_Flush,IF_ID_Wre,
    input wire Branch,//新增Branch
    input wire Clk,
    
    //数据通路
    input wire [31:0] IF_Instruction,
    input wire [31:0] IF_PCadd4,
    
    output reg [31:0] ID_Instruction,//取出的32位的指令
    output reg[5:0] Opcode,
    output reg[4:0] rs,rt,rd,sa,
    output reg[5:0] func,
    output reg[15:0] Immediate,
    output reg[25:0] targetAddress,
    
    output reg [31:0] ID_PCadd4 //取出的PC+4
    );
    
    //初始化
    initial begin
        ID_Instruction=0;
        Opcode=0;
        rs=0;rt=0;rd=0;sa=0;
        func=0;
        Immediate=0;
        targetAddress=0;
        
        ID_PCadd4=0;
    end
    
 //代码1：wire类型的输出  
//    //初始化寄存器
//    reg [31:0] register[0:1];//32个寄存器，每个寄存器32位
//    integer i;
//    initial begin
//        for(i = 0;i < 2;i=i+1) 
//            register[i] <= 0;//每个寄存器初始化为0
//    end
    
//    //读取
//    assign ID_PCadd4=register[0];
//    assign ID_Instruction=register[1];
//    //把指令中的各个字段分开
//    assign Opcode=ID_Instruction[31:26];//应该是IF?
//    assign rs=ID_Instruction[25:21];
//    assign rt=ID_Instruction[20:16];
//    assign rd=ID_Instruction[15:11];
//    assign sa=ID_Instruction[10:6];
//    assign func=ID_Instruction[5:0];
//    assign Immediate=ID_Instruction[15:0];
//    assign targetAddress=IF_Instruction[25:0];

//    //写入
//    always @(negedge Clk) begin 
//       if(IF_ID_Wre==1 && IF_ID_Flush==0) begin
//            register[0]<= IF_PCadd4;
//            register[1]<= IF_Instruction;
//       end
//    end
    
//    //处理分支
//    always @(*)begin
//        if(IF_ID_Flush==1) begin     
//                //register[0]= 0;
//                register[1]= 32'b001001_00000_00000_0000_0000_0000_0000;//nop
//        end
//    end
   
 //代码2：reg类型的输出,但是有问题
     //读取
     
//     //写入
//    always @(negedge Clk) begin 
//        if(IF_ID_Wre==1 && IF_ID_Flush==0) begin
//            ID_Instruction<=IF_Instruction;
//            Opcode<=IF_Instruction[31:26];
//            rs<=IF_Instruction[25:21];
//            rt<=IF_Instruction[20:16];
//            rd<=IF_Instruction[15:11];
//            sa<=IF_Instruction[10:6];
//            func<=IF_Instruction[5:0];
//            Immediate<=IF_Instruction[15:0];
//            targetAddress<=IF_Instruction[25:0];
            
//            ID_PCadd4<=IF_PCadd4;
//        end
        
//       if(IF_ID_Flush==1) begin
//            ID_Instruction<=32'b001001_00000_00000_0000_0000_0000_0000;//nop
//            Opcode<=32'b001001;
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];
            
//            ID_PCadd4<=0;
//       end
//     end

 //代码3：reg类型的输出,Clk的下降沿写入，上升沿检查IF_ID_Flush==1
    always @(negedge Clk or posedge Clk) begin 
        if(Clk==0) begin
            if(IF_ID_Wre==1&& IF_ID_Flush==0) begin  //不能删去: && IF_ID_Flush==0
                ID_Instruction<=IF_Instruction;
                Opcode<=IF_Instruction[31:26];
                rs<=IF_Instruction[25:21];
                rt<=IF_Instruction[20:16];
                rd<=IF_Instruction[15:11];
                sa<=IF_Instruction[10:6];
                func<=IF_Instruction[5:0];
                Immediate<=IF_Instruction[15:0];
                targetAddress<=IF_Instruction[25:0];
                
                ID_PCadd4<=IF_PCadd4;
            end
        end
        
        else//Clk==1
        begin
        
             //对于分支指令
            if( IF_ID_Flush==1) 
            begin 
               if(Branch==1) begin
                    ID_Instruction<=0;
                    Opcode<=0;//清除旧Opcode,否则上一条指令的PCWre会在下一个周期起作用
                    rs<=0;
                    rt<=0;
                    rd<=0;
                    sa<=0;
                    func<=0;
                    Immediate<=0;
                    targetAddress<=IF_Instruction[25:0];//保持不变
                    
                    ID_PCadd4<=IF_PCadd4;
                end
            
            
                //对于跳转指令
                else 
                begin
                    ID_Instruction<=0;
                    Opcode<=IF_Instruction[31:26];//保留旧Opcode,否则控制信号会被刷新
                    rs<=0;
                    rt<=0;
                    rd<=0;
                    sa<=0;
                    func<=0;
                    Immediate<=0;
                    targetAddress<=IF_Instruction[25:0];//保持不变
                    
                    ID_PCadd4<=IF_PCadd4;//保持不变
                end
                
            end
        end
    end                                                                                                                                                                                                                                                                                                                                      
//    always @(posedge Clk) begin 
       
//       //对于分支指令
//        if(Branch==1 && IF_ID_Flush==1) begin 
//            ID_Instruction<=0;
//            Opcode<=0;//清除旧Opcode,否则上一条指令的PCWre会在下一个周期起作用
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//保持不变
            
//            ID_PCadd4<=IF_PCadd4;//保持不变
//        end
        
//        //对于跳转指令
//        else if(IF_ID_Flush==1) begin
//            ID_Instruction<=0;
//            Opcode<=IF_Instruction[31:26];//保留旧Opcode,否则控制信号会被刷新
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//保持不变
            
//            ID_PCadd4<=IF_PCadd4;//保持不变
//        end
//    end
    
//    //代码4：配合Jump信号使用。（代码3的改进版）
//    always @(negedge Clk) begin 
//        if(IF_ID_Wre==1&& IF_ID_Flush==0 ) begin  //删去: && IF_ID_Flush==0
//            ID_Instruction<=IF_Instruction;
//            Opcode<=IF_Instruction[31:26];
//            rs<=IF_Instruction[25:21];
//            rt<=IF_Instruction[20:16];
//            rd<=IF_Instruction[15:11];
//            sa<=IF_Instruction[10:6];
//            func<=IF_Instruction[5:0];
//            Immediate<=IF_Instruction[15:0];
//            targetAddress<=IF_Instruction[25:0];
            
//            ID_PCadd4<=IF_PCadd4;
//        end
//    end
    
//    always @(posedge Clk) begin 
       
//       //对于分支指令
//        if(Branch==1 && IF_ID_Flush==1) begin 
//            ID_Instruction<=0;
//            Opcode<=0;//清除旧Opcode,否则上一条指令的PCWre会在下一个周期起作用
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//保持不变
            
//            ID_PCadd4<=IF_PCadd4;//保持不变
//        end
        
//        //对于跳转指令
//        else if(IF_ID_Flush==1) begin
//            ID_Instruction<=0;
//            Opcode<=0;//IF_Instruction[31:26];不必保留旧Opcode，因为有Jump信号
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//保持不变
            
//            ID_PCadd4<=IF_PCadd4;//保持不变
//        end
//    end

////代码5：gpt建议
//always @(posedge Clk) begin 
//    if (IF_ID_Flush == 1) begin
//        // 如果 IF_ID_Flush 为 1，清除指令寄存器
//        ID_Instruction <= 32'b0;
//        Opcode <= 6'b0;
//        rs <= 5'b0;
//        rt <= 5'b0;
//        rd <= 5'b0;
//        sa <= 5'b0;
//        func <= 6'b0;
//        Immediate <= 16'b0;
//        targetAddress <= 26'b0;
//        ID_PCadd4 <= 32'b0;
//    end
//    else if (IF_ID_Wre == 1) begin
//        // 如果 IF_ID_Wre 为 1，并且没有 Flush，正常写入
//        ID_Instruction <= IF_Instruction;
//        Opcode <= IF_Instruction[31:26];
//        rs <= IF_Instruction[25:21];
//        rt <= IF_Instruction[20:16];
//        rd <= IF_Instruction[15:11];
//        sa <= IF_Instruction[10:6];
//        func <= IF_Instruction[5:0];
//        Immediate <= IF_Instruction[15:0];
//        targetAddress <= IF_Instruction[25:0];
//        ID_PCadd4 <= IF_PCadd4;
//    end
//end

//// 处理分支指令的逻辑
//always @(posedge Clk) begin
//    if (Branch == 1 && IF_ID_Flush == 1) begin
//        // 如果是分支指令并且 Flush 为 1，清除所有寄存器的值
//        ID_Instruction <= 32'b0;
//        Opcode <= 6'b0;
//        rs <= 5'b0;
//        rt <= 5'b0;
//        rd <= 5'b0;
//        sa <= 5'b0;
//        func <= 6'b0;
//        Immediate <= 16'b0;
//        targetAddress <= IF_Instruction[25:0];  // 目标地址保持不变
//        ID_PCadd4 <= IF_PCadd4;  // PC 地址保持不变
//    end
//end
endmodule
