`timescale 1ns / 1ps

module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);

    reg [31:0] memory [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;

        $readmemh("program.hex", memory);
    end

    // Each instruction is 4 bytes
    assign instruction = memory[address[9:2]];

endmodule


