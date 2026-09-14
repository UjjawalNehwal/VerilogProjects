`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2026 02:15:56
// Design Name: 
// Module Name: TB_CPU
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

module tb_CPU;

    reg clk;
    reg reset;

    // ============================================================
    // MAIN CPU SIGNALS
    // ============================================================

    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] alu_result;
    wire [31:0] mem_data;

    integer cycle;


    // ============================================================
    // DEBUG SIGNALS
    // ============================================================

    wire [4:0] debug_rs1;
    wire [4:0] debug_rs2;
    wire [4:0] debug_rd;

    wire [31:0] debug_rs1_data;
    wire [31:0] debug_rs2_data;

    wire [31:0] debug_immediate;

    wire [31:0] debug_alu_input_a;
    wire [31:0] debug_alu_input_b;
    wire [3:0] debug_alu_control;
    wire debug_zero;

    wire debug_reg_write;
    wire debug_alu_src;
    wire debug_mem_read;
    wire debug_mem_write;
    wire debug_branch;

    wire [31:0] debug_mem_write_data;

    wire [31:0] debug_write_back_data;

    wire debug_branch_taken;
    wire [31:0] debug_branch_target;

    wire [31:0] debug_pc_plus_4;
    wire [31:0] debug_next_pc;


    // ============================================================
    // CPU
    // ============================================================

    CPU dut (

        .clk(clk),
        .reset(reset),

        .pc(pc),
        .instruction(instruction),
        .alu_result(alu_result),
        .mem_data(mem_data),

        // Debug
        .debug_rs1(debug_rs1),
        .debug_rs2(debug_rs2),
        .debug_rd(debug_rd),

        .debug_rs1_data(debug_rs1_data),
        .debug_rs2_data(debug_rs2_data),

        .debug_immediate(debug_immediate),

        .debug_alu_input_a(debug_alu_input_a),
        .debug_alu_input_b(debug_alu_input_b),
        .debug_alu_control(debug_alu_control),
        .debug_zero(debug_zero),

        .debug_reg_write(debug_reg_write),
        .debug_alu_src(debug_alu_src),
        .debug_mem_read(debug_mem_read),
        .debug_mem_write(debug_mem_write),
        .debug_branch(debug_branch),

        .debug_mem_write_data(debug_mem_write_data),

        .debug_write_back_data(debug_write_back_data),

        .debug_branch_taken(debug_branch_taken),
        .debug_branch_target(debug_branch_target),

        .debug_pc_plus_4(debug_pc_plus_4),
        .debug_next_pc(debug_next_pc)
    );


    // ============================================================
    // CLOCK
    // ============================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // ============================================================
    // SIMULATION
    // ============================================================

    initial begin

        cycle = 0;

        reset = 1'b1;

        $display("");
        $display("==============================================================");
        $display("             RV32I SINGLE-CYCLE CPU SIMULATION");
        $display("==============================================================");

        // Reset
        repeat (2) @(posedge clk);

        reset = 1'b0;

        // Execute program
        repeat (40) @(posedge clk);

        // Final register values
        print_registers;

        $finish;

    end


    // ============================================================
    // CYCLE COUNTER
    // ============================================================

    always @(posedge clk) begin

        cycle = cycle + 1;

    end


    // ============================================================
    // FINAL REGISTER DUMP
    // ============================================================

    task print_registers;

        integer i;

        begin

            $display("");
            $display("");
            $display("==============================================================");
            $display("                 FINAL REGISTER VALUES");
            $display("==============================================================");

            for (i = 0; i < 32; i = i + 1) begin

                $display(
                    "x%0d  = %08h",
                    i,
                    dut.rf.regs[i]
                );

            end

            $display("==============================================================");
            $display("");

        end

    endtask

endmodule