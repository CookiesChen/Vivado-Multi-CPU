`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 21:31:53
// Design Name: 
// Module Name: Multi_CPU
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/23 13:23:13
// Design Name: 
// Module Name: Single_CPU
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


module Multi_CPU( CLK, RST, addr, next_PC, IDataOut, ReadData1, ReadData2, result, DB);
    input CLK;
    input RST;
    
    
    //Control Unit
    wire zero;
    wire sign;
    wire PCWre;
    wire ALUSrcA;
    wire ALUSrcB;
    wire DBDataSrc;
    wire RegWre;
    wire WrRegDSrc;
    wire nRD;
    wire nWR;
    wire IRWre;
    wire ExtSel;
    wire [1:0] PCSrc;
    wire [1:0] RegDst;
    wire [2:0] ALUOp;
    
    //IM
    output wire [31:0] addr;
    output wire [31:0] IDataOut;
    
    //Regfile
    output wire[31:0] ReadData1;
    output wire [31:0] ReadData2;
    wire [31:0] WriteData;
    wire [4:0] WriteReg;
    
    //PC
    wire [31:0] PC4;
    
    //Next_PC
    output wire [31:0] next_PC;
    //Extend
    wire [31:0] exten;
    
    //ALU
    output wire [31:0] result;
    wire [31:0] rega;
    wire [31:0] regb;
    
    //RAM
    wire [31:0] Dataout;
    
    //WB
    output wire [31:0] DB;
    
    //IR
    wire [31:0] IDataOut_Out;
    
    //ADR
    wire [31:0] ReadData1_Out;
    
    //BDR
    wire [31:0] ReadData2_Out;
    
    //ALUoutDR
    wire [31:0] result_Out;
    
    wire [31:0] DB_Out;
    
    assign rega = (ALUSrcA == 0) ?  ReadData1_Out : {24'h000000, 3'b000, IDataOut[10:6]};
    assign regb = (ALUSrcB == 0) ?  ReadData2_Out : exten;
    assign WriteReg = (RegDst == 2'b00) ? 5'b11111 : (RegDst == 2'b01) ? IDataOut_Out[20:16] : IDataOut_Out[15:11];
    assign DB = (DBDataSrc == 0) ? result : Dataout;
    assign WriteData = (WrRegDSrc == 1)? DB_Out:PC4;
    
    PC my_PC(.CLK(CLK),.RST(RST),.PCWre(PCWre),.PC_in(next_PC),.addr(addr),.PC4(PC4));
    Next_PC my_Next_PC(.PC4(PC4),.exten(exten << 2),.addr(addr),.ReadData1(ReadData1),.PCSrc(PCSrc),.next_PC(next_PC));
    IM my_IM(.addr(addr), .IDataOut(IDataOut));
    Control_Unit my_Control_Unit(.CLK(CLK),.RST(RST),.op(IDataOut_Out[31:26]),.zero(zero),.sign(sign),.PCWre(PCWre),
                                 .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),.DBDataSrc(DBDataSrc),.RegWre(RegWre),.WrRegDSrc(WrRegDSrc),.nRD(nRD),
                                 .nWR(nWR),.IRWre(IRWre),.ExtSel(ExtSel),.PCSrc(PCSrc),.RegDst(RegDst),.ALUOp(ALUOp));
    Reg_file my_Reg_file(.CLK(CLK), .RST(RST), .RegWre(RegWre), .ReadReg1(IDataOut_Out[25:21]), .ReadReg2(IDataOut_Out[20:16]), .WriteReg(WriteReg), .WriteData(WriteData), .ReadData1(ReadData1), .ReadData2(ReadData2));
    Extend_Unit my_Extend_Unit(.ExtSel(ExtSel), .ime(IDataOut_Out[15:0]), .exten(exten));
    ALU my_ALU(.ALUopcode(ALUOp), .rega(rega), .regb(regb), .result(result), .zero(zero),.sign(sign));
    RAM my_RAM(.clk(CLK), .address(result), .writeData(ReadData2_Out), .nRD(nRD), .nWR(nWR), .Dataout(Dataout));
    IR my_IR(.CLK(CLK), .IRWre(IRWre), .IDataOut(IDataOut), .IDataOut_Out(IDataOut_Out));
    ADR my_ADR(.CLK(CLK), .ReadData1(ReadData1), .ReadData1_Out(ReadData1_Out));
    BDR my_BDR(.CLK(CLK), .ReadData2(ReadData2), .ReadData2_Out(ReadData2_Out));
    ALUoutDR my_ALUoutDR(.CLK(CLK), .result(result), .result_Out(result_Out));
    DBDR my_DBDR(.CLK(CLK), .DB(DB), .DB_Out(DB_Out));
endmodule

