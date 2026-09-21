`timescale 1ns/1ps

module tb_riscv;

    // =========================================================
    // DUT Signals
    // =========================================================
    reg clk;
    reg reset;

    wire [31:0] PC_out;
    wire [31:0] ALUResult_out;
    wire [31:0] WriteData_out;
    wire [31:0] Instr_out;


    wire RegWrite_out;
    wire [4:0] rd_out;

    wire [31:0] x1_out;
    wire [31:0] x2_out;
    wire [31:0] x3_out;  
    wire [31:0] x4_out;
    wire [31:0] x5_out;
    wire [31:0] x6_out; 
    wire [31:0] x7_out;
    wire [31:0] x8_out;
    wire [31:0] x9_out; 
    wire [31:0] x10_out;
    // =========================================================
    // Instantiate CPU
    // =========================================================
    cpu_core dut (
        .clk(clk),
        .reset(reset),
        .PC_out(PC_out),
        .ALUResult_out(ALUResult_out),
        .WriteData_out(WriteData_out),
        .Instr_out(Instr_out),

        .RegWrite_out(RegWrite_out),
        .rd_out(rd_out),
        .x1_out(x1_out),
        .x2_out(x2_out),
        .x3_out(x3_out),
        .x4_out(x4_out),
        .x5_out(x5_out),
        .x6_out(x6_out),
        .x7_out(x7_out),
        .x8_out(x8_out),
        .x9_out(x9_out),
        .x10_out(x10_out)

    );

    // =========================================================
    // Clock Generation
    // 10ns period
    // =========================================================
    initial clk = 0;
    always #5 clk = ~clk;

    // =========================================================
    // Dump waveform
    // =========================================================
    initial begin
        $dumpfile("wave/dump.vcd");
        $dumpvars(0, tb_riscv);
    end

    // =========================================================
    // Helper Task
    // =========================================================
    task print_state;
        input [31:0] cycle;
        begin
            $display(
                "Cycle=%0d | PC=%08h | INSTR=%08h | ALU=%08h | WD=%08h",
                cycle,
                PC_out,
                Instr_out,
                ALUResult_out,
                WriteData_out
            );
        end
    endtask

    // =========================================================
    // Simulation
    // =========================================================
    integer cyc;

    initial begin

        $display("==================================================");
        $display("     RISC-V Single Cycle CPU Simulation");
        $display("==================================================");

        // Reset
        reset = 1;

        @(negedge clk);
        @(negedge clk);

        reset = 0;

        // Run simulation
        for (cyc = 1; cyc <= 10; cyc = cyc + 1) begin
            @(posedge clk);
            #1;
            print_state(cyc);
        end

        // =====================================================
        // Register Dump
        // =====================================================
        $display("");
        $display("============== REGISTER FILE ==============");

        $display("x1  = %0d", dut.dp.rf.rf[1]);
        $display("x2  = %0d", dut.dp.rf.rf[2]);
        $display("x3  = %0d", dut.dp.rf.rf[3]);
        $display("x4  = %0d", dut.dp.rf.rf[4]);
        $display("x5  = %0d", dut.dp.rf.rf[5]);
        $display("x6  = %0d", dut.dp.rf.rf[6]);
        $display("x7  = %0d", dut.dp.rf.rf[7]);
        $display("x8  = %0d", dut.dp.rf.rf[8]);
        $display("x9  = %0d", dut.dp.rf.rf[9]);
        $display("x10 = %0d", dut.dp.rf.rf[10]);

        $display("");

        // =====================================================
        // PASS / FAIL CHECK
        // =====================================================
        if (
            dut.dp.rf.rf[1]  == 32'd10 &&
            dut.dp.rf.rf[2]  == 32'd20 &&
            dut.dp.rf.rf[3]  == 32'd30 &&
            dut.dp.rf.rf[4]  == 32'hfffffff6 &&
            dut.dp.rf.rf[5]  == 32'd0  &&
            dut.dp.rf.rf[6]  == 32'd30 &&
            dut.dp.rf.rf[7]  == 32'd30 &&
            dut.dp.rf.rf[8]  == 32'd1  &&
            dut.dp.rf.rf[9]  == 32'd1  &&
            dut.dp.rf.rf[10] == 32'd20
        )
        begin
            $display("*** ALL CHECKS PASSED ***");
        end
        else
        begin
            $display("!!! SOME CHECKS FAILED !!!");
        end

        $display("==================================================");

        $finish;
    end

endmodule
