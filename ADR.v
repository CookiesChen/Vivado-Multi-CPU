`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 21:45:17
// Design Name: 
// Module Name: ADR
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


module ADR(
    input CLK,
    input [31:0] ReadData1,
    output reg [31:0] ReadData1_Out
    );
    
    always@(posedge CLK) begin
        ReadData1_Out = ReadData1;
    end
    
endmodule
