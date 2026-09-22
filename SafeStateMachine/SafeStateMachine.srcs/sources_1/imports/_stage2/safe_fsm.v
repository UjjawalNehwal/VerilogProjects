`timescale 1ns / 1ps
//=============================================================================
// Safe State Machine Design - one-hot encoding with fault recovery
//   4 legal one-hot states cycle S0->S1->S2->S3->S0 while 'go' is held.
//   Any state value that is NOT one of the 4 legal one-hot codes (e.g. from
//   an SEU bit-flip corrupting the state register) is caught by the `case`
//   statement's `default` arm, which forces recovery to S0 on the next
//   clock and raises fault_detected for that cycle. This is the standard
//   "safe FSM" pattern for one-hot designs.
//=============================================================================
module safe_fsm (
    input  wire       clk,
    input  wire       rst,     // synchronous, active-high
    input  wire       go,
    output reg  [3:0] state_out,      // one-hot state bus (observability)
    output reg         fault_detected
);

    localparam [3:0] S0 = 4'b0001,
                      S1 = 4'b0010,
                      S2 = 4'b0100,
                      S3 = 4'b1000;

    reg [3:0] state, next_state;

    // (1) state register
    always @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next_state;
    end

    // (2) next-state logic, with illegal-state recovery
    always @(*) begin
        fault_detected = 1'b0;
        case (state)
            S0: next_state = go ? S1 : S0;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S0;
            default: begin
                next_state      = S0;   // safe recovery from any illegal code
                fault_detected  = 1'b1;
            end
        endcase
    end

    // (3) output logic
    always @(*) begin
        state_out = state;
    end

endmodule
