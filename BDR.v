`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 21:45:35
// Design Name: 
// Module Name: BDR
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


module BDR(
    input CLK,
    input [31:0] ReadData2,
    output reg [31:0] ReadData2_Out
    );
    
    always@(posedge CLK) begin
        ReadData2_Out = ReadData2;
    end
    
endmodule
