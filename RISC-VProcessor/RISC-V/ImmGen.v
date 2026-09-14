`timescale 1ns / 1ps

module ImmGen (
    input [31:0] instruction,
    output reg [31:0] immediate
);

    wire [6:0] opcode;

    assign opcode = instruction[6:0];

    always @(*) begin

        case (opcode)

            // --------------------------------
            // I-Type Arithmetic
            // --------------------------------
            7'b0010011: begin

                // SLLI, SRLI, SRAI
                if (instruction[14:12] == 3'b001 ||
                    instruction[14:12] == 3'b101) begin

                    immediate = {
                        27'b0,
                        instruction[24:20]
                    };

                end
                else begin

                    immediate = {
                        {20{instruction[31]}},
                        instruction[31:20]
                    };

                end
            end

            // --------------------------------
            // LW
            // --------------------------------
            7'b0000011: begin
                immediate = {
                    {20{instruction[31]}},
                    instruction[31:20]
                };
            end

            // --------------------------------
            // SW
            // --------------------------------
            7'b0100011: begin
                immediate = {
                    {20{instruction[31]}},
                    instruction[31:25],
                    instruction[11:7]
                };
            end

            // --------------------------------
            // Branch
            // --------------------------------
            7'b1100011: begin
                immediate = {
                    {19{instruction[31]}},
                    instruction[31],
                    instruction[7],
                    instruction[30:25],
                    instruction[11:8],
                    1'b0
                };
            end

            // --------------------------------
            // LUI
            // --------------------------------
            7'b0110111: begin
                immediate = {
                    instruction[31:12],
                    12'b0
                };
            end

            default: begin
                immediate = 32'b0;
            end

        endcase

    end

endmodule

