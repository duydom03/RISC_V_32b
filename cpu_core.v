// module cpu_core (
//     input  wire        clk,
//     input  wire        reset,
//     output wire [31:0] PC_out,
//     output wire [31:0] ALUResult_out,
//     output wire [31:0] WriteData_out,
//     output wire [31:0] Instr_out,

//      // debug
//    output wire RegWrite_out,
//    output wire [4:0] rd_out,
 
//    output wire [31:0] x1_out,
//    output wire [31:0] x2_out,
//    output wire [31:0] x3_out,
//    output wire [31:0] x4_out,
//    output wire [31:0] x5_out,
//    output wire [31:0] x6_out,
//    output wire [31:0] x7_out,
//    output wire [31:0] x8_out,
//    output wire [31:0] x9_out,
//    output wire [31:0] x10_out 
//  );
//     wire [31:0] instr, ReadData, ALUResult, PC, WriteData;
//     wire RegWrite, ALUSrc, MemWrite, isJALR, isJAL, isBEQ, Zero;
//     wire [1:0] ResultSrc;
//     wire [2:0] ImmSrc;
//     wire [3:0] ALUCtrl;
 
//     imem imem_inst (
//         .addr(PC), .instr(instr)
//     );
 
//     Control_Unit cu (
//         .op(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]),
//         .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemWrite(MemWrite),
//         .ResultSrc(ResultSrc), .ImmSrc(ImmSrc), .ALUCtrl(ALUCtrl),
//         .isBEQ(isBEQ), .isJAL(isJAL), .isJALR(isJALR)
//     );
 
//     datapath dp (
//         .clk(clk), .reset(reset), .instr(instr),
//         .RegWrite(RegWrite), .ALUSrc(ALUSrc), .ALUCtrl(ALUCtrl),
//         .MemWrite(MemWrite), .ResultSrc(ResultSrc), .ImmSrc(ImmSrc),
//         .isJALR(isJALR), .isJAL(isJAL), .isBEQ(isBEQ),
//         .ReadData(ReadData), .WriteData(WriteData),
//         .ALUResult(ALUResult), .PC(PC), .Zero(Zero)
//     );
 
//     dmem dmem_inst (
//         .clk(clk), .we(MemWrite), .addr(ALUResult),
//         .wd(WriteData), .rd(ReadData)
//     );
 
//     assign PC_out         = PC;
//     assign ALUResult_out  = ALUResult;
//     assign WriteData_out  = WriteData;
//     assign Instr_out      = instr;

//     // debug
//    assign RegWrite_out = RegWrite;
//    assign rd_out       = instr[11:7];

//    assign x1_out  = dp.rf.rf[1];
//    assign x2_out  = dp.rf.rf[2];
//    assign x3_out  = dp.rf.rf[3];
//    assign x4_out  = dp.rf.rf[4];
//    assign x5_out  = dp.rf.rf[5];
//    assign x6_out  = dp.rf.rf[6];
//    assign x7_out  = dp.rf.rf[7];
//    assign x8_out  = dp.rf.rf[8];
//    assign x9_out  = dp.rf.rf[9];
//    assign x10_out = dp.rf.rf[10];
// endmodule
 

 module cpu_core (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] PC_out,
    output wire [31:0] ALUResult_out,
    output wire [31:0] WriteData_out,
    output wire [31:0] Instr_out,

    // debug
    output wire        RegWrite_out,
    output wire [4:0]  rd_out
);
    wire [31:0] instr, ReadData, ALUResult, PC, WriteData;
    wire RegWrite, ALUSrc, MemWrite, isJALR, isJAL, isBEQ, Zero;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [3:0] ALUCtrl;

    imem imem_inst (
        .addr(PC), .instr(instr)
    );

    Control_Unit cu (
        .op(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]),
        .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemWrite(MemWrite),
        .ResultSrc(ResultSrc), .ImmSrc(ImmSrc), .ALUCtrl(ALUCtrl),
        .isBEQ(isBEQ), .isJAL(isJAL), .isJALR(isJALR)
    );

    datapath dp (
        .clk(clk), .reset(reset), .instr(instr),
        .RegWrite(RegWrite), .ALUSrc(ALUSrc), .ALUCtrl(ALUCtrl),
        .MemWrite(MemWrite), .ResultSrc(ResultSrc), .ImmSrc(ImmSrc),
        .isJALR(isJALR), .isJAL(isJAL), .isBEQ(isBEQ),
        .ReadData(ReadData), .WriteData(WriteData),
        .ALUResult(ALUResult), .PC(PC), .Zero(Zero)
    );

    dmem dmem_inst (
        .clk(clk), .we(MemWrite), .addr(ALUResult),
        .wd(WriteData), .rd(ReadData)
    );

    assign PC_out        = PC;
    assign ALUResult_out = ALUResult;
    assign WriteData_out = WriteData;
    assign Instr_out     = instr;

    // debug
    assign RegWrite_out = RegWrite;
    assign rd_out       = instr[11:7];

endmodule