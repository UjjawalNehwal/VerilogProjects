`timescale 1ns / 1ps
//=============================================================================
// Clock Domain Crossing - 2-Flip-Flop Synchronizer
//   Brings an asynchronous (or foreign-clock-domain) signal into the dst_clk
//   domain with two back-to-back registers, reducing the probability of a
//   metastable value propagating downstream. Adds 2 dst_clk cycles latency.
//
//   Note: this is the standard functional model. Real CDC safety also
//   requires physical-only placement close together and false-path /
//   async-clock-group timing constraints (not modeled in RTL simulation).
//=============================================================================
module cdc_2ff_sync #(
    parameter integer WIDTH = 1
)(
    input  wire               dst_clk,
    input  wire               rst,      // synchronous, active-high, dst_clk domain
    input  wire [WIDTH-1:0]   async_in,
    output reg  [WIDTH-1:0]   sync_out
);

    reg [WIDTH-1:0] meta_ff;   // first stage: may go metastable, not used externally

    always @(posedge dst_clk) begin
        if (rst) begin
            meta_ff  <= {WIDTH{1'b0}};
            sync_out <= {WIDTH{1'b0}};
        end else begin
            meta_ff  <= async_in;
            sync_out <= meta_ff;
        end
    end

endmodule
