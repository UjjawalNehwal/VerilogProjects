`timescale 1ns / 1ps
//=============================================================================
// Fixed-Priority Arbiter
//   Purely combinational: grants the lowest-indexed asserted request.
//=============================================================================
module fixed_priority_arbiter #(
    parameter integer N = 4
)(
    input  wire [N-1:0] req,
    output reg  [N-1:0] grant
);
    integer i;
    always @(*) begin
        grant = {N{1'b0}};
        for (i = 0; i < N; i = i + 1) begin
            if (req[i] && (grant == {N{1'b0}}))
                grant[i] = 1'b1;
        end
    end
endmodule


//=============================================================================
// Round-Robin Arbiter
//   State = index of the last granted requester. Each cycle, priority
//   rotates to start just after that index, so no requester is starved as
//   long as it keeps asking. grant is registered (1 cycle latency vs req).
//=============================================================================
module round_robin_arbiter #(
    parameter integer N = 4
)(
    input  wire          clk,
    input  wire          rst,     // synchronous, active-high
    input  wire [N-1:0]  req,
    output reg  [N-1:0]  grant
);

    localparam integer PW = (N > 1) ? $clog2(N) : 1;

    reg  [PW-1:0] last_grant, next_last_grant;
    reg  [N-1:0]  next_grant;
    integer k;
    integer idx;

    // (1) state register (last granted index)
    always @(posedge clk) begin
        if (rst) last_grant <= {PW{1'b0}};
        else     last_grant <= next_last_grant;
    end

    // (2) next-state + next-grant logic: scan starting just after last_grant
    always @(*) begin
        next_grant      = {N{1'b0}};
        next_last_grant = last_grant;
        for (k = 0; k < N; k = k + 1) begin
            idx = (last_grant + 1 + k) % N;
            if (req[idx] && (next_grant == {N{1'b0}})) begin
                next_grant[idx] = 1'b1;
                next_last_grant = idx[PW-1:0];
            end
        end
    end

    // (3) output register (registered grant)
    always @(posedge clk) begin
        if (rst) grant <= {N{1'b0}};
        else     grant <= next_grant;
    end

endmodule
