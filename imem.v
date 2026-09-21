// -----------------------------------------------------------
//  Instruction Memory (ROM)
// -----------------------------------------------------------
module imem (
    input  wire [31:0] addr,
    output wire [31:0] instr
);
    reg [31:0] rom [0:63];
    initial begin
        $readmemh("programR.mem", rom);
    end
    assign instr = rom[addr[7:2]];
endmodule