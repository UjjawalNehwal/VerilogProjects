`timescale 1ns / 1ps

module RegisterFile (
    input clk,
    input we,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,

    input [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] regs [0:31];

    integer i;

    // Initialize all registers to zero
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    // x0 is always zero
    assign read_data1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];

    // Register write
    always @(posedge clk) begin
        if (we && (rd != 5'd0))
            regs[rd] <= write_data;

        // Ensure x0 remains zero
        regs[0] <= 32'b0;
    end

endmodule


