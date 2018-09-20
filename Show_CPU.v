`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/14 12:47:27
// Design Name: 
// Module Name: Show_CPU
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


module Show_CPU(
    input clock,
    input BTNR,
    input Reset,
    input SW_15,
    input SW_14,
    output Y0,
    output Y1,
    output Y2,
    output Y3,
    output Y4,
    output Y5,
    output Y6,
    output Y7,
    output [3:0] Enable
    );
    wire clk_sys;
    wire [31:0] PC;
    wire [31:0] next_PC;
    wire [31:0] IDataOut;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] result;
    wire [31:0] DB;
    
    wire [3:0] disp;
    
    reg [7:0] in1;
    reg [7:0] in2;
    
    wire [7:0] out;
    
    assign {Y7,Y6,Y5,Y4,Y3,Y2,Y1,Y0} = out;
    
    always @(SW_15 or SW_14 or clock) begin
        case({SW_15, SW_14})
            2'b00 : begin
                in1 = PC[7:0];
                in2 = next_PC[7:0];
            end
            2'b01 : begin
                in1 = {3'b000,IDataOut[25:21]};
                in2 = ReadData1[7:0];
            end
            2'b10 : begin
                in1 = {3'b000,IDataOut[20:16]};
                in2 = ReadData2[7:0];
            end
            2'b11 : begin
                in1 = result[7:0];
                in2 = DB[7:0];
            end
        endcase
    end
    
    wire but;
    
    Multi_CPU my_Multi_CPU(.CLK(but), .RST(Reset), .addr(PC), .next_PC(next_PC), .IDataOut(IDataOut), .ReadData1(ReadData1), .ReadData2(ReadData2), .result(result), .DB(DB));
    clock_div my_clock_div(.clk(clock), .clk_sys(clk_sys));
    choose_output my_choose_output(.clk(clk_sys), .in1(in1), .in2(in2), .Enable(Enable), .disp(disp));
    seven_seg my_seven_seg(.display_data(disp), .dispcode(out));
    key_but my_key_but(.clk(clock), .in(BTNR), .out(but));
    
endmodule
