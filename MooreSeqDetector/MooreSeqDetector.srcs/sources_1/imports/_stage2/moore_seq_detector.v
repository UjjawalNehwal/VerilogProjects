`timescale 1ns / 1ps
//=============================================================================
// Moore Sequence Detector for pattern "1001"
//   Classic 3-always-block FSM template:
//     1) state register            (sequential)
//     2) next-state logic          (combinational)
//     3) output logic              (combinational, Moore: f(state) only)
//
//   Needs an extra state S4 vs. the Mealy version, since a Moore machine's
//   output can only change on a state transition, never within a state.
//
//   OVERLAP = 1 : from S4, treat the trailing '1' as a possible new match
//   OVERLAP = 0 : from S4, restart the search from scratch
//=============================================================================
module moore_seq_detector #(
    parameter integer OVERLAP = 1
)(
    input  wire clk,
    input  wire rst,      // synchronous, active-high
    input  wire din,
    output reg  detected   // Moore output: function of state only
);

    localparam [2:0] S0 = 3'd0,  // matched ""
                      S1 = 3'd1,  // matched "1"
                      S2 = 3'd2,  // matched "10"
                      S3 = 3'd3,  // matched "100"
                      S4 = 3'd4;  // matched "1001" -- detected

    reg [2:0] state, next_state;

    // (1) state register
    always @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next_state;
    end

    // (2) next-state logic
    always @(*) begin
        case (state)
            S0: next_state = din ? S1 : S0;
            S1: next_state = din ? S1 : S2;
            S2: next_state = din ? S1 : S3;
            S3: next_state = din ? S4 : S0;
            S4: next_state = OVERLAP ? (din ? S1 : S2)
                                      : (din ? S1 : S0);
            default: next_state = S0;
        endcase
    end

    // (3) output logic (Moore)
    always @(*) begin
        detected = (state == S4);
    end

endmodule
