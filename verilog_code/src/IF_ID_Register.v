`timescale 1ns / 1ps

module IF_ID_Register(
    //�����ź�
    input wire IF_ID_Flush,IF_ID_Wre,
    input wire Branch,//����Branch
    input wire Clk,
    
    //����ͨ·
    input wire [31:0] IF_Instruction,
    input wire [31:0] IF_PCadd4,
    
    output reg [31:0] ID_Instruction,//ȡ����32λ��ָ��
    output reg[5:0] Opcode,
    output reg[4:0] rs,rt,rd,sa,
    output reg[5:0] func,
    output reg[15:0] Immediate,
    output reg[25:0] targetAddress,
    
    output reg [31:0] ID_PCadd4 //ȡ����PC+4
    );
    
    //��ʼ��
    initial begin
        ID_Instruction=0;
        Opcode=0;
        rs=0;rt=0;rd=0;sa=0;
        func=0;
        Immediate=0;
        targetAddress=0;
        
        ID_PCadd4=0;
    end
    
 //����1��wire���͵����  
//    //��ʼ���Ĵ���
//    reg [31:0] register[0:1];//32���Ĵ�����ÿ���Ĵ���32λ
//    integer i;
//    initial begin
//        for(i = 0;i < 2;i=i+1) 
//            register[i] <= 0;//ÿ���Ĵ�����ʼ��Ϊ0
//    end
    
//    //��ȡ
//    assign ID_PCadd4=register[0];
//    assign ID_Instruction=register[1];
//    //��ָ���еĸ����ֶηֿ�
//    assign Opcode=ID_Instruction[31:26];//Ӧ����IF?
//    assign rs=ID_Instruction[25:21];
//    assign rt=ID_Instruction[20:16];
//    assign rd=ID_Instruction[15:11];
//    assign sa=ID_Instruction[10:6];
//    assign func=ID_Instruction[5:0];
//    assign Immediate=ID_Instruction[15:0];
//    assign targetAddress=IF_Instruction[25:0];

//    //д��
//    always @(negedge Clk) begin 
//       if(IF_ID_Wre==1 && IF_ID_Flush==0) begin
//            register[0]<= IF_PCadd4;
//            register[1]<= IF_Instruction;
//       end
//    end
    
//    //�����֧
//    always @(*)begin
//        if(IF_ID_Flush==1) begin     
//                //register[0]= 0;
//                register[1]= 32'b001001_00000_00000_0000_0000_0000_0000;//nop
//        end
//    end
   
 //����2��reg���͵����,����������
     //��ȡ
     
//     //д��
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

 //����3��reg���͵����,Clk���½���д�룬�����ؼ��IF_ID_Flush==1
    always @(negedge Clk or posedge Clk) begin 
        if(Clk==0) begin
            if(IF_ID_Wre==1&& IF_ID_Flush==0) begin  //����ɾȥ: && IF_ID_Flush==0
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
        
             //���ڷ�ָ֧��
            if( IF_ID_Flush==1) 
            begin 
               if(Branch==1) begin
                    ID_Instruction<=0;
                    Opcode<=0;//�����Opcode,������һ��ָ���PCWre������һ������������
                    rs<=0;
                    rt<=0;
                    rd<=0;
                    sa<=0;
                    func<=0;
                    Immediate<=0;
                    targetAddress<=IF_Instruction[25:0];//���ֲ���
                    
                    ID_PCadd4<=IF_PCadd4;
                end
            
            
                //������תָ��
                else 
                begin
                    ID_Instruction<=0;
                    Opcode<=IF_Instruction[31:26];//������Opcode,��������źŻᱻˢ��
                    rs<=0;
                    rt<=0;
                    rd<=0;
                    sa<=0;
                    func<=0;
                    Immediate<=0;
                    targetAddress<=IF_Instruction[25:0];//���ֲ���
                    
                    ID_PCadd4<=IF_PCadd4;//���ֲ���
                end
                
            end
        end
    end                                                                                                                                                                                                                                                                                                                                      
//    always @(posedge Clk) begin 
       
//       //���ڷ�ָ֧��
//        if(Branch==1 && IF_ID_Flush==1) begin 
//            ID_Instruction<=0;
//            Opcode<=0;//�����Opcode,������һ��ָ���PCWre������һ������������
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//���ֲ���
            
//            ID_PCadd4<=IF_PCadd4;//���ֲ���
//        end
        
//        //������תָ��
//        else if(IF_ID_Flush==1) begin
//            ID_Instruction<=0;
//            Opcode<=IF_Instruction[31:26];//������Opcode,��������źŻᱻˢ��
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//���ֲ���
            
//            ID_PCadd4<=IF_PCadd4;//���ֲ���
//        end
//    end
    
//    //����4�����Jump�ź�ʹ�á�������3�ĸĽ��棩
//    always @(negedge Clk) begin 
//        if(IF_ID_Wre==1&& IF_ID_Flush==0 ) begin  //ɾȥ: && IF_ID_Flush==0
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
       
//       //���ڷ�ָ֧��
//        if(Branch==1 && IF_ID_Flush==1) begin 
//            ID_Instruction<=0;
//            Opcode<=0;//�����Opcode,������һ��ָ���PCWre������һ������������
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//���ֲ���
            
//            ID_PCadd4<=IF_PCadd4;//���ֲ���
//        end
        
//        //������תָ��
//        else if(IF_ID_Flush==1) begin
//            ID_Instruction<=0;
//            Opcode<=0;//IF_Instruction[31:26];���ر�����Opcode����Ϊ��Jump�ź�
//            rs<=0;
//            rt<=0;
//            rd<=0;
//            sa<=0;
//            func<=0;
//            Immediate<=0;
//            targetAddress<=IF_Instruction[25:0];//���ֲ���
            
//            ID_PCadd4<=IF_PCadd4;//���ֲ���
//        end
//    end

////����5��gpt����
//always @(posedge Clk) begin 
//    if (IF_ID_Flush == 1) begin
//        // ��� IF_ID_Flush Ϊ 1�����ָ��Ĵ���
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
//        // ��� IF_ID_Wre Ϊ 1������û�� Flush������д��
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

//// �����ָ֧����߼�
//always @(posedge Clk) begin
//    if (Branch == 1 && IF_ID_Flush == 1) begin
//        // ����Ƿ�ָ֧��� Flush Ϊ 1��������мĴ�����ֵ
//        ID_Instruction <= 32'b0;
//        Opcode <= 6'b0;
//        rs <= 5'b0;
//        rt <= 5'b0;
//        rd <= 5'b0;
//        sa <= 5'b0;
//        func <= 6'b0;
//        Immediate <= 16'b0;
//        targetAddress <= IF_Instruction[25:0];  // Ŀ���ַ���ֲ���
//        ID_PCadd4 <= IF_PCadd4;  // PC ��ַ���ֲ���
//    end
//end
endmodule
