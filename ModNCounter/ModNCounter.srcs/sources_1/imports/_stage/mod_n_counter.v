`timescale 1ns / 1ps
//=============================================================================
// Modulo-N Counter with Synchronous Load & Enable
//   - Synchronous active-high reset
//   - Synchronous parallel load (overrides count, has priority over enable)
//   - Enable gates counting
//   - Wraps 0 .. N-1
//   - tc (terminal count) pulses high when count == N-1
//=============================================================================
module mod_n_counter #(
    parameter integer N     = 10,   // modulus
    parameter integer WIDTH = 4     // must satisfy 2**WIDTH >= N
)(
    input  wire                 clk,
    input  wire                 rst,       // synchronous, active-high
    input  wire                 en,
    input  wire                 load,
    input  wire [WIDTH-1:0]     load_val,
    output reg  [WIDTH-1:0]     count,
    output wire                 tc
);

    assign tc = (count == N-1);

    always @(posedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (load)
            count <= load_val;
        else if (en) begin
            if (count == N-1)
                count <= {WIDTH{1'b0}};
            else
                count <= count + 1'b1;
        end
    end

endmodule
