`timescale 1ns / 1ps
//=============================================================================
// Simple Handshake Protocol FSM (Req/Ack signaling, 4-phase)
//   IDLE        : req=0, waits for 'start'
//   REQ_HIGH    : req=1, waits for ack=1
//   REQ_LOW_WAIT: req=0, waits for ack to fall back to 0 (completes 4-phase
//                 handshake); 'done' pulses for the cycle ack is seen low.
//=============================================================================
module handshake_fsm (
    input  wire clk,
    input  wire rst,     // synchronous, active-high
    input  wire start,
    input  wire ack,
    output reg  req,
    output reg  done
);

    localparam [1:0] S_IDLE         = 2'd0,
                      S_REQ_HIGH    = 2'd1,
                      S_REQ_LOW_WAIT = 2'd2;

    reg [1:0] state, next_state;

    // (1) state register
    always @(posedge clk) begin
        if (rst) state <= S_IDLE;
        else     state <= next_state;
    end

    // (2) next-state logic
    always @(*) begin
        case (state)
            S_IDLE:          next_state = start ? S_REQ_HIGH : S_IDLE;
            S_REQ_HIGH:      next_state = ack   ? S_REQ_LOW_WAIT : S_REQ_HIGH;
            S_REQ_LOW_WAIT:  next_state = ack   ? S_REQ_LOW_WAIT : S_IDLE;
            default:         next_state = S_IDLE;
        endcase
    end

    // (3) output logic
    always @(*) begin
        req  = (state == S_REQ_HIGH);
        done = (state == S_REQ_LOW_WAIT) && !ack;   // one-cycle pulse
    end

endmodule
