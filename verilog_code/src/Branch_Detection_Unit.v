`timescale 1ns / 1ps

module Branch_Detection_Unit(
    //�����ź�
    input wire [1:0] MEM_BranchType,
   
    //����ͨ·
    input wire MEM_Zero, MEM_Sign,
    output reg Branch
    );
    always @(*) begin
        if(MEM_BranchType==2'b01 && MEM_Zero==1) Branch=1;//��beqָ��,�Ҽ�����Ϊ0��˵����ȣ���Ҫ��֧
        else if(MEM_BranchType==2'b10 && MEM_Zero==0) Branch=1;//��bneָ��,�Ҽ�������Ϊ0��˵������ȣ���Ҫ��֧
        else if(MEM_BranchType==2'b11 && MEM_Sign==1) Branch=1;//��bltzָ��,�Ҽ�����Ϊ<0��Ҫ��֧
        else Branch=0; //���Ƿ�ָ֧��򲻷�֧
    end
    
endmodule
