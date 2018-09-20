`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/14 12:45:45
// Design Name: 
// Module Name: key_but
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


module key_but(
    input clk,
    input in,
    output out
    );
    
    reg [31:0] low;
    reg [31:0] high;
    
    reg out_reg;
    always @(posedge clk) begin
        if(in == 0) low = low + 1;
        else low = 0;
    end
    
    always @(posedge clk) begin
        if(in == 1) high = high + 1;
        else high = 0;
    end
    
    always @(posedge clk) begin
        if(high == 20'hfffff) out_reg = 1;
        else if(low == 20'hfffff) out_reg = 0;
    end
    
    assign out = out_reg;
endmodule
