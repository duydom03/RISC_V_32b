// -----------------------------------------------------------
//  Data Memory (RAM)
// -----------------------------------------------------------
module dmem (
    input  wire        clk,
    input  wire        we,
    input  wire [31:0] addr,
    input  wire [31:0] wd,
    output wire [31:0] rd
);
    reg [31:0] ram [0:255];
    integer i;
    initial for (i = 0; i < 256; i = i + 1) ram[i] = 32'b0;
 
    assign rd = ram[addr[9:2]];
    always @(posedge clk) begin
        if (we) ram[addr[9:2]] <= wd;
    end
endmodule