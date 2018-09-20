`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 21:45:56
// Design Name: 
// Module Name: ALUoutDR
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


module ALUoutDR(
    input CLK,
    input [31:0] result,
    output reg [31:0] result_Out
    );
    
    always@(posedge CLK) begin
        result_Out = result;
    end
    
endmodule
