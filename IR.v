`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 21:42:50
// Design Name: 
// Module Name: IR
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


module IR(
    input CLK,
    input IRWre,
    input [31:0] IDataOut,
    output reg [31:0] IDataOut_Out
    );
    
    always@(negedge CLK) begin
        if(IRWre == 1) IDataOut_Out = IDataOut;
    end
    
endmodule
