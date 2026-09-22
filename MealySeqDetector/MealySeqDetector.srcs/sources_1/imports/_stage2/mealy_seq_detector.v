`timescale 1ns / 1ps
//=============================================================================
// Mealy Sequence Detector for pattern "1001"
//   Classic 3-always-block FSM template:
//     1) state register            (sequential)
//     2) next-state logic          (combinational)
//     3) output logic              (combinational, Mealy: f(state, input))
//
//   OVERLAP = 1 : after a match, keep the trailing '1' as a possible start
//                 of the next match (e.g. "1001001" finds 2 matches)
//   OVERLAP = 0 : after a match, restart the search from scratch
//=============================================================================
module mealy_seq_detector #(
    parameter integer OVERLAP = 1
)(
    input  wire clk,
    input  wire rst,      // synchronous, active-high
    input  wire din,
    output reg  detected   // Mealy output: combinational function of state+din
);

    localparam [1:0] S0 = 2'd0,  // matched ""
                      S1 = 2'd1,  // matched "1"
                      S2 = 2'd2,  // matched "10"
                      S3 = 2'd3;  // matched "100"

    reg [1:0] state, next_state;

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
            S3: next_state = din ? (OVERLAP ? S1 : S0) : S0;
            default: next_state = S0;
        endcase
    end

    // (3) output logic (Mealy)
    always @(*) begin
        detected = (state == S3) && din;
    end

endmodule
