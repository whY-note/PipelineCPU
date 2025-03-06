`timescale 1ns / 1ps
//ѡ��д��ļĴ������

module RegDst_Mux(
    //�����ź�
    input wire[1:0] RegDst,
    
    //����ͨ·
    input wire[4:0] rt,rd,
    output wire [4:0] WriteReg
    );
    
    // MUXѡ�񣺸���RegDstѡ��Ŀ��Ĵ���
    // ���RegDst�� 00��ѡ��rt�����RegDst�� 01��ѡ��rd�����RegDst�� 10��ѡ��$31������jal��ָ���
    assign WriteReg=(RegDst==2'b00)? rt:
                    (RegDst==2'b01)? rd:
                     5'd31;
                     
endmodule
