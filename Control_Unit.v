`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/22 19:56:50
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input CLK,
    input RST,
    input [5:0] op,
    input zero,
    input sign,
    output reg PCWre,
    output wire ALUSrcA,
    output wire ALUSrcB,
    output wire DBDataSrc,
    output wire RegWre,
    output wire WrRegDSrc,
    output wire nRD,
    output wire nWR,
    output wire IRWre,
    output wire ExtSel,
    output reg [1:0] PCSrc,
    output wire [1:0] RegDst,
    output reg [2:0] ALUOp
);
    reg [2:0] State = 3'b000;
    wire [5:0] op_add = 6'b000000;
    wire [5:0] op_sub = 6'b000001;
    wire [5:0] op_addi = 6'b000010;
    wire [5:0] op_or = 6'b010000;
    wire [5:0] op_and = 6'b010001;
    wire [5:0] op_ori = 6'b010010;
    wire [5:0] op_sll = 6'b011000;
    wire [5:0] op_slt = 6'b100110;
    wire [5:0] op_sltiu = 6'b100111;
    wire [5:0] op_sw = 6'b110000;
    wire [5:0] op_lw = 6'b110001;
    wire [5:0] op_beq = 6'b110100;
    wire [5:0] op_bltz = 6'b110110;
    wire [5:0] op_j = 6'b111000;
    wire [5:0] op_jr = 6'b111001;
    wire [5:0] op_jal = 6'b111010;
    wire [5:0] op_halt = 6'b111111;
    
    initial begin 
        State = 3'b000;
        PCSrc = 2'b00;
        PCWre = 0;
    end
    
    //¸Ä±ä×´Ì¬
    always @(posedge CLK or negedge RST) begin
        if(RST == 0) begin
            State = 3'b000;
        end
        else begin
            case(State)
                3'b000 : State = 3'b001;
                3'b001 : begin
                    if(op == op_j || op == op_jal || op == op_jr || op == op_halt) State = 3'b000;
                    else State = 3'b010;
                end
                3'b010 : begin
                    if(op == op_beq || op == op_bltz) State = 3'b000;
                    else if(op == op_sw || op == op_lw) State = 3'b100;
                    else State = 3'b011;
                end
                3'b011 : State = 3'b000;
                3'b100 : begin
                    if(op == op_sw) State = 3'b000;
                    else State = 3'b011;
                end
            endcase
          
            
            case(op) //ALUOp
                6'b000000: ALUOp = 3'b000; //add
                6'b000001: ALUOp = 3'b001; //sub
                6'b000010: ALUOp = 3'b000; //addi
                6'b010000: ALUOp = 3'b011; //or
                6'b010001: ALUOp = 3'b100; //and
                6'b010010: ALUOp = 3'b011; //ori
                6'b011000: ALUOp = 3'b010; //sll
                6'b100110: ALUOp = 3'b110; //slt
                6'b100111: ALUOp = 3'b101; //sltiu
                6'b110000: ALUOp = 3'b000; //sw
                6'b110001: ALUOp = 3'b000; //lw
                6'b110100: ALUOp = 3'b001; //beq
                6'b110110: ALUOp = 3'b110; //blt
                6'b111000: ALUOp = 3'b000; //j
            endcase
            
        end
    end
    
    always @(op or zero or sign) begin
        if(RST == 0) begin
            PCSrc = 2'b00;
        end
        else begin
            case(op) //PCSrc
                6'b110100: begin //beq
                    if(zero == 0) PCSrc = 2'b00;
                    else PCSrc = 2'b01;
                end
                6'b110110: begin //bltz
                    if(zero == 1 || sign == 0) PCSrc = 2'b00;
                    else if(zero == 0 && sign == 1) PCSrc = 2'b01;
                end
                6'b111001: PCSrc = 2'b10; //jr
                6'b111000: PCSrc = 2'b11; //j
                6'b111010: PCSrc = 2'b11; //jal
                default: PCSrc = 2'b00;
            endcase
        end
    end
    
    always @(negedge CLK) begin
        if(State == 3'b001 && (op == op_j || op == op_jr || op == op_jal)) PCWre = 1;
        else if(State == 3'b010 && (op == op_beq || op == op_bltz)) PCWre = 1;
        else if(State == 3'b100 && (op == op_sw)) PCWre = 1;
        else if(State == 3'b011 && (op == op_lw || op == op_add || op == op_sub || op == op_addi || op == op_or || 
                                    op == op_and || op == op_ori || op == op_sll || op == op_slt || op == op_sltiu)) PCWre = 1;
        else PCWre = 0;
    end
    
    assign ALUSrcA = (op == op_sll) ? 1 : 0;
    assign ALUSrcB = (op == op_addi || op == op_ori || op == op_sltiu || op == op_sw || op == op_lw) ? 1 : 0;
    assign DBDataSrc = (op == op_lw) ? 1 : 0;
    assign RegWre = ((op == op_add || op == op_sub || op == op_addi || op == op_or || op == op_and || op == op_ori ||
                     op == op_slt || op == op_sltiu || op == op_sll || op == op_lw) && State == 3'b011 ) || (op == op_jal && State == 3'b001)? 1 : 0;
    assign WrRegDSrc = (op == op_jal) ? 0 : 1;
    assign nRD = (op == op_lw && State == 3'b100) ? 1 : 0;
    assign nWR = (op == op_sw && State == 3'b100) ? 1 : 0;
    assign IRWre = (RST == 0) ? 1 : (State == 3'b000) ? 1 : 0;
    assign ExtSel = (op == op_ori || op == op_sltiu) ? 0 : 1;
    assign RegDst = (op == op_addi || op == op_ori || op == op_sltiu || op == op_lw)? 2'b01:(op == op_jal) ? 2'b00:2'b10;
    
endmodule
