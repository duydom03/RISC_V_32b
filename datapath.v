// module datapath (
//     input  wire        clk,
//     input  wire        reset,
//     input  wire [31:0] instr,
//     input  wire        RegWrite, ALUSrc, MemWrite,
//     input  wire [1:0]  ResultSrc,
//     input  wire [2:0]  ImmSrc,
//     input  wire [3:0]  ALUCtrl,
//     input  wire        isJALR, isJAL, isBEQ,
//     input  wire [31:0] ReadData,
//     output wire [31:0] WriteData, ALUResult,
//     output wire [31:0] PC,
//     output wire        Zero
// );
//     wire [31:0] PCNext, PCPlus4, ImmExt, SrcA, SrcB, ALUOut, Result;
 
//     assign PCPlus4 = PC + 4;
 
//     pc pc_reg (
//         .clk(clk), .reset(reset),
//         .PCNext(PCNext), .PC(PC)
//     );
 
//     regfile rf (
//         .clk(clk), .we3(RegWrite),
//         .a1(instr[19:15]), .a2(instr[24:20]), .a3(instr[11:7]),
//         .wd3(Result), .rd1(SrcA), .rd2(WriteData)
//     );
 
//     ImmGen imm_gen (
//         .instr(instr), .ImmSrc(ImmSrc), .imm_out(ImmExt)
//     );
 
//     assign SrcB = ALUSrc ? ImmExt : WriteData;
 
//     ALU alu_unit (
//         .A(SrcA), .B(SrcB),
//         .ALUControl(ALUCtrl),
//         .Result(ALUOut), .Zero(Zero)
//     );
 
//     assign ALUResult = ALUOut;
 
//     assign Result = (ResultSrc == 2'b00) ? ALUOut  :
//                     (ResultSrc == 2'b01) ? ReadData :
//                     (ResultSrc == 2'b10) ? PCPlus4  : 32'b0;
 
//     wire PCSrc = isJAL | (isBEQ & Zero);
//     assign PCNext = isJALR ? ((SrcA + ImmExt) & 32'hFFFFFFFE) :
//                     PCSrc  ? (PC + ImmExt)                     :
//                               PCPlus4;
// endmodule
 

 module datapath (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] instr,
    input  wire        RegWrite, ALUSrc, MemWrite,
    input  wire [1:0]  ResultSrc,
    input  wire [2:0]  ImmSrc,
    input  wire [3:0]  ALUCtrl,
    input  wire        isJALR, isJAL, isBEQ,
    input  wire [31:0] ReadData,
    output wire [31:0] WriteData, ALUResult,
    output wire [31:0] PC,
    output wire        Zero
);
    wire [31:0] PCNext, PCPlus4, ImmExt, SrcA, SrcB, ALUOut, Result;

    assign PCPlus4 = PC + 4;

    pc pc_reg (
        .clk(clk), .reset(reset),
        .PCNext(PCNext), .PC(PC)
    );

    regfile rf (
        .clk(clk), .we3(RegWrite),
        .a1(instr[19:15]), .a2(instr[24:20]), .a3(instr[11:7]),
        .wd3(Result), .rd1(SrcA), .rd2(WriteData)
    );

    ImmGen imm_gen (
        .instr(instr), .ImmSrc(ImmSrc), .imm_out(ImmExt)
    );

    assign SrcB = ALUSrc ? ImmExt : WriteData;

    ALU alu_unit (
        .A(SrcA), .B(SrcB),
        .ALUControl(ALUCtrl),
        .Result(ALUOut), .Zero(Zero)
    );

    assign ALUResult = ALUOut;

    assign Result = (ResultSrc == 2'b00) ? ALUOut  :
                    (ResultSrc == 2'b01) ? ReadData :
                    (ResultSrc == 2'b10) ? PCPlus4  : 32'b0;

    wire PCSrc = isJAL | (isBEQ & Zero);
    assign PCNext = isJALR ? ((SrcA + ImmExt) & 32'hFFFFFFFE) :
                    PCSrc  ? (PC + ImmExt)                     :
                             PCPlus4;
endmodule