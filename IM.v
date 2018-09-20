`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/22 15:33:52
// Design Name: 
// Module Name: Instruction_Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IM(
    input [31:0] addr, // �洢����ַ
    output reg [31:0] IDataOut // ���������
    );
    reg RW;
    reg [7:0] InsMemory[0:100];
    initial begin // �������ݵ��洢��rom��ע�⣺����ʹ�þ���·�����磺E:/Xlinx/VivadoProject/ROM/���Լ�����
        RW = 0;
        $readmemb ("C:/Users/11093/Desktop/��ҵ/���/��/����/������CPU/������CPUʵ��/ins.txt", InsMemory); // �����ļ�rom_data��.coe��.txt����δָ�����ʹ�0��ַ��ʼ��š�
    end
    always @( RW or addr ) begin
        if (RW == 0) begin // Ϊ0�����洢����������ݴ洢ģʽ
            IDataOut[31:24] = InsMemory[addr];
            IDataOut[23:16] = InsMemory[addr+1];
            IDataOut[15:8] = InsMemory[addr+2];
            IDataOut[7:0] = InsMemory[addr+3];
        end
    end
endmodule
