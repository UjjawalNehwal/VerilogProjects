`timescale 1ns / 1ps
//=============================================================================
// Linear Feedback Shift Register (Fibonacci/external-XOR form)
//   - Default TAPS = 8'hB8 (bits 7,5,4,3) implements the standard maximal-
//     length 8-bit polynomial x^8 + x^6 + x^5 + x^4 + 1 (period 255)
//   - Shifts left, feedback = XOR of tapped bits, injected at LSB
//   - Guards against the illegal/locking all-zero state on reset and on load
//=============================================================================
module lfsr_prng #(
    parameter integer WIDTH        = 8,
    parameter [WIDTH-1:0] TAPS     = 8'hB8
)(
    input  wire                 clk,
    input  wire                 rst,     // synchronous, active-high
    input  wire                 en,
    input  wire                 load,
    input  wire [WIDTH-1:0]     seed,
    output reg  [WIDTH-1:0]     lfsr_out
);

    wire feedback = ^(lfsr_out & TAPS);

    always @(posedge clk) begin
        if (rst)
            lfsr_out <= {WIDTH{1'b1}};
        else if (load)
            lfsr_out <= (seed == {WIDTH{1'b0}}) ? {WIDTH{1'b1}} : seed;
        else if (en)
            lfsr_out <= {lfsr_out[WIDTH-2:0], feedback};
    end

endmodule
