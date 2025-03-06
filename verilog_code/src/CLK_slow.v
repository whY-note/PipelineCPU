`timescale 1ns / 1ps

//��Ƶģ��

module CLK_slow(
    input CLK_100mhz,//100mhz��ԭʼʱ���ź�
    
    output reg CLK_slow//����ķ�Ƶʱ���ź�
);

reg [31:0] count = 0;//������
reg [31:0] N = 50000;//��Ƶ2^19���õ�һ�����ڴ�Լ5ms���ź�

initial CLK_slow = 0;

always @ (posedge CLK_100mhz) begin
    if(count >= N) begin
        count <= 0;
        CLK_slow <= ~CLK_slow;
    end
    else
        count <= count + 1;

end

endmodule 