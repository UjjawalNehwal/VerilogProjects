`timescale 1ns / 1ps
//=============================================================================
// Clock Divider - Power-of-2
//   - clk_out = free-running counter bit [DIV_BITS-1]
//   - Produces a perfect 50% duty cycle, divide ratio = 2**DIV_BITS
//=============================================================================
module clk_div_pow2 #(
    parameter integer DIV_BITS = 4     // divide ratio = 2**DIV_BITS
)(
    input  wire  clk_in,
    input  wire  rst,      // synchronous, active-high
    output wire  clk_out
);

    reg [DIV_BITS-1:0] cnt;

    always @(posedge clk_in) begin
        if (rst)
            cnt <= {DIV_BITS{1'b0}};
        else
            cnt <= cnt + 1'b1;
    end

    assign clk_out = cnt[DIV_BITS-1];

endmodule


//=============================================================================
// Clock Divider - Odd Integer (N >= 3, N odd)
//   - Classic dual-counter technique: one counter advances on the input
//     clock's rising edge, the other on its falling edge; each is high for
//     the first (N-1)/2 counts of its period. OR-ing the two gives an output
//     with period N*Tclk_in and duty cycle as close to 50% as an odd divide
//     allows ((N+1)/(2N) high vs (N-1)/(2N) low).
//=============================================================================
module clk_div_odd #(
    parameter integer N = 5            // odd divide ratio, N >= 3
)(
    input  wire  clk_in,
    input  wire  rst,      // synchronous, active-high (applied on both edges)
    output wire  clk_out
);

    localparam integer CBITS = $clog2(N);
    localparam integer HALF  = (N-1)/2;

    reg [CBITS-1:0] pos_cnt, neg_cnt;
    reg pos_clk, neg_clk;

    always @(posedge clk_in) begin
        if (rst) begin
            pos_cnt <= {CBITS{1'b0}};
            pos_clk <= 1'b0;
        end else begin
            pos_cnt <= (pos_cnt == N-1) ? {CBITS{1'b0}} : (pos_cnt + 1'b1);
            pos_clk <= (pos_cnt < HALF);
        end
    end

    always @(negedge clk_in) begin
        if (rst) begin
            neg_cnt <= {CBITS{1'b0}};
            neg_clk <= 1'b0;
        end else begin
            neg_cnt <= (neg_cnt == N-1) ? {CBITS{1'b0}} : (neg_cnt + 1'b1);
            neg_clk <= (neg_cnt < HALF);
        end
    end

    assign clk_out = pos_clk | neg_clk;

endmodule
