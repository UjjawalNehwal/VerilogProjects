`timescale 1ns / 1ps

module CPU (
    input clk,
    input reset,

    // Main outputs
    output [31:0] pc,
    output [31:0] instruction,
    output [31:0] alu_result,
    output [31:0] mem_data,

    // ============================================================
    // DEBUG OUTPUTS
    // ============================================================

    // Register information
    output [4:0]  debug_rs1,
    output [4:0]  debug_rs2,
    output [4:0]  debug_rd,

    output [31:0] debug_rs1_data,
    output [31:0] debug_rs2_data,

    // Immediate
    output [31:0] debug_immediate,

    // ALU
    output [31:0] debug_alu_input_a,
    output [31:0] debug_alu_input_b,
    output [3:0]  debug_alu_control,
    output        debug_zero,

    // Control signals
    output debug_reg_write,
    output debug_alu_src,
    output debug_mem_read,
    output debug_mem_write,
    output debug_branch,

    // Memory
    output [31:0] debug_mem_write_data,

    // Write back
    output [31:0] debug_write_back_data,

    // Branch
    output debug_branch_taken,
    output [31:0] debug_branch_target,

    // PC
    output [31:0] debug_pc_plus_4,
    output [31:0] debug_next_pc
);

    // ============================================================
    // INTERNAL WIRES
    // ============================================================

    wire [31:0] next_pc;
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;

    // Control
    wire reg_write;
    wire alu_src;
    wire mem_read;
    wire mem_write;
    wire branch;

    wire [3:0] alu_control;

    // Register file
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] write_back_data;

    // Immediate
    wire [31:0] immediate;

    // ALU
    wire [31:0] alu_input_b;
    wire zero;

    // Branch
    wire branch_taken;


    // ============================================================
    // PROGRAM COUNTER
    // ============================================================

    PC pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    assign pc_plus_4 = pc + 32'd4;


    // ============================================================
    // INSTRUCTION MEMORY
    // ============================================================

    InstructionMemory imem (
        .address(pc),
        .instruction(instruction)
    );


    // ============================================================
    // CONTROL UNIT
    // ============================================================

    ControlUnit control (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .alu_control(alu_control)
    );


    // ============================================================
    // REGISTER FILE
    // ============================================================

    RegisterFile rf (
        .clk(clk),
        .we(reg_write),

        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),

        .write_data(write_back_data),

        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );


    // ============================================================
    // IMMEDIATE GENERATOR
    // ============================================================

    ImmGen imm_gen (
        .instruction(instruction),
        .immediate(immediate)
    );


    // ============================================================
    // ALU INPUT B MUX
    // ============================================================

    assign alu_input_b = alu_src ? immediate : rs2_data;


    // ============================================================
    // ALU
    // ============================================================

    ALU alu (
        .a(rs1_data),
        .b(alu_input_b),
        .alu_control(alu_control),

        .result(alu_result),
        .zero(zero)
    );


    // ============================================================
    // DATA MEMORY
    // ============================================================

    DataMemory dmem (
        .clk(clk),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .address(alu_result),
        .write_data(rs2_data),

        .read_data(mem_data)
    );


    // ============================================================
    // WRITE BACK
    // ============================================================

    assign write_back_data =
        mem_read ? mem_data : alu_result;


    // ============================================================
    // BRANCH LOGIC
    // ============================================================

    assign branch_taken =
        branch &&
        (
            ((instruction[14:12] == 3'b000) && zero) ||
            ((instruction[14:12] == 3'b001) && !zero)
        );

    assign branch_target = pc + immediate;

    assign next_pc =
        branch_taken ? branch_target : pc_plus_4;


    // ============================================================
    // DEBUG OUTPUT CONNECTIONS
    // ============================================================

    assign debug_rs1 = instruction[19:15];
    assign debug_rs2 = instruction[24:20];
    assign debug_rd  = instruction[11:7];

    assign debug_rs1_data = rs1_data;
    assign debug_rs2_data = rs2_data;

    assign debug_immediate = immediate;

    assign debug_alu_input_a = rs1_data;
    assign debug_alu_input_b = alu_input_b;
    assign debug_alu_control = alu_control;
    assign debug_zero = zero;

    assign debug_reg_write = reg_write;
    assign debug_alu_src = alu_src;
    assign debug_mem_read = mem_read;
    assign debug_mem_write = mem_write;
    assign debug_branch = branch;

    assign debug_mem_write_data = rs2_data;

    assign debug_write_back_data = write_back_data;

    assign debug_branch_taken = branch_taken;
    assign debug_branch_target = branch_target;

    assign debug_pc_plus_4 = pc_plus_4;
    assign debug_next_pc = next_pc;

endmodule




