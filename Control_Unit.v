module Control_Unit (
    input  [6:0] op,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg   RegWrite, ALUSrc, MemWrite,
    output reg [1:0] ResultSrc,
    output reg [2:0] ImmSrc,
    output reg [3:0] ALUCtrl,
    output reg   isBEQ, isJAL, isJALR
);
    always @(*) begin
        RegWrite = 0; ALUSrc = 0; MemWrite = 0; ResultSrc = 2'b00;
        ImmSrc = 3'b000; ALUCtrl = 4'b0000; isBEQ = 0; isJAL = 0; isJALR = 0;
        case (op)
            // R-type
            7'b0110011: begin
                RegWrite = 1;
                case (funct3)
                    3'b000: ALUCtrl = funct7[5] ? 4'b0001 : 4'b0000; // SUB : ADD
                    3'b001: ALUCtrl = 4'b0010; // SLL
                    3'b010: ALUCtrl = 4'b0011; // SLT
                    3'b011: ALUCtrl = 4'b0100; // SLTU
                    3'b100: ALUCtrl = 4'b0101; // XOR
                    3'b101: ALUCtrl = funct7[5] ? 4'b0111 : 4'b0110; // SRA : SRL
                    3'b110: ALUCtrl = 4'b1000; // OR
                    3'b111: ALUCtrl = 4'b1001; // AND
                    default: ALUCtrl = 4'b0000;
                endcase
            end
            // I-type ALU
            7'b0010011: begin
                RegWrite = 1; ALUSrc = 1; ImmSrc = 3'b000;
                case (funct3)
                    3'b000: ALUCtrl = 4'b0000; // ADDI
                    3'b001: ALUCtrl = 4'b0010; // SLLI
                    3'b010: ALUCtrl = 4'b0011; // SLTI
                    3'b011: ALUCtrl = 4'b0100; // SLTIU
                    3'b100: ALUCtrl = 4'b0101; // XORI
                    3'b101: ALUCtrl = funct7[5] ? 4'b0111 : 4'b0110; // SRAI : SRLI
                    3'b110: ALUCtrl = 4'b1000; // ORI
                    3'b111: ALUCtrl = 4'b1001; // ANDI
                    default: ALUCtrl = 4'b0000;
                endcase
            end
            // Load (LW)
            7'b0000011: begin
                RegWrite = 1; ALUSrc = 1; ImmSrc = 3'b000;
                ResultSrc = 2'b01; ALUCtrl = 4'b0000;
            end
            // Store (SW)
            7'b0100011: begin
                MemWrite = 1; ALUSrc = 1; ImmSrc = 3'b001; ALUCtrl = 4'b0000;
            end
            // Branch (BEQ)
            7'b1100011: begin
                ImmSrc = 3'b010; isBEQ = 1; ALUCtrl = 4'b0001;
            end
            // JAL
            7'b1101111: begin
                RegWrite = 1; ImmSrc = 3'b100; ResultSrc = 2'b10; isJAL = 1;
            end
            // JALR
            7'b1100111: begin
                RegWrite = 1; ALUSrc = 1; ImmSrc = 3'b000;
                ResultSrc = 2'b10; isJALR = 1;
            end
            default: ;
        endcase
    end
endmodule