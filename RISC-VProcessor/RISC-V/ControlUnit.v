`timescale 1ns / 1ps

module ControlUnit (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg [3:0] alu_control
);

    // ALU control codes
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_XOR  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_AND  = 4'b0100;
    localparam ALU_SLL  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRA  = 4'b0111;
    localparam ALU_SLT  = 4'b1000;
    localparam ALU_SLTU = 4'b1001;
    localparam ALU_LUI  = 4'b1010;

    always @(*) begin

        // Default values
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        alu_control = ALU_ADD;

        case (opcode)

            // --------------------------------
            // R-Type
            // --------------------------------
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;

                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SUB;
                        else
                            alu_control = ALU_ADD;
                    end

                    3'b001:
                        alu_control = ALU_SLL;

                    3'b010:
                        alu_control = ALU_SLT;

                    3'b011:
                        alu_control = ALU_SLTU;

                    3'b100:
                        alu_control = ALU_XOR;

                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;
                        else
                            alu_control = ALU_SRL;
                    end

                    3'b110:
                        alu_control = ALU_OR;

                    3'b111:
                        alu_control = ALU_AND;

                    default:
                        alu_control = ALU_ADD;

                endcase
            end

            // ====================================================
            // I-TYPE ALU INSTRUCTIONS
            // ====================================================
            
            7'b0010011: begin
            
                reg_write = 1'b1;
                alu_src   = 1'b1;
            
                case (funct3)
            
                    3'b000: alu_control = ALU_ADD;   // ADDI
                    3'b001: alu_control = ALU_SLL;   // SLLI
                    3'b010: alu_control = ALU_SLT;   // SLTI
                    3'b011: alu_control = ALU_SLTU;  // SLTIU
                    3'b100: alu_control = ALU_XOR;   // XORI
            
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;   // SRAI
                        else
                            alu_control = ALU_SRL;   // SRLI
                    end
            
                    3'b110: alu_control = ALU_OR;    // ORI
                    3'b111: alu_control = ALU_AND;   // ANDI
            
                    default:
                        alu_control = ALU_ADD;
            
                endcase
            end     

            // --------------------------------
            // LW
            // --------------------------------
            7'b0000011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                mem_read  = 1'b1;
                alu_control = ALU_ADD;
            end

            // --------------------------------
            // SW
            // --------------------------------
            7'b0100011: begin
                alu_src    = 1'b1;
                mem_write  = 1'b1;
                alu_control = ALU_ADD;
            end

            // --------------------------------
            // Branch
            // --------------------------------
            7'b1100011: begin
                branch = 1'b1;
                alu_src = 1'b0;

                // ALU performs subtraction
                // for BEQ/BNE comparison.
                alu_control = ALU_SUB;
            end

            // --------------------------------
            // LUI
            // --------------------------------
            7'b0110111: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_control = ALU_LUI;
            end

            default: begin
                reg_write  = 1'b0;
                alu_src    = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                alu_control = ALU_ADD;
            end

        endcase
    end

endmodule

