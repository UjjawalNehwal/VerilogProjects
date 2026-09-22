`timescale 1ns / 1ps
//=============================================================================
// Traffic Light Controller FSM with Timers (North-South / East-West)
//   4 states, each held for a parameterized number of clock cycles:
//     NS_GREEN -> NS_YELLOW -> EW_GREEN -> EW_YELLOW -> (repeat)
//
//   Light encoding: 2'b10 = Green, 2'b01 = Yellow, 2'b00 = Red
//
//   Structure: state register, timer (datapath) register, next-state
//   combinational logic, output combinational logic.
//=============================================================================
module traffic_light_fsm #(
    parameter integer GREEN_TIME  = 10,   // cycles
    parameter integer YELLOW_TIME = 3     // cycles
)(
    input  wire       clk,
    input  wire       rst,     // synchronous, active-high
    output reg  [1:0] ns_light,
    output reg  [1:0] ew_light
);

    localparam [1:0] S_NS_GREEN  = 2'd0,
                      S_NS_YELLOW = 2'd1,
                      S_EW_GREEN  = 2'd2,
                      S_EW_YELLOW = 2'd3;

    localparam integer TW = (GREEN_TIME > YELLOW_TIME) ?
                              $clog2(GREEN_TIME+1) : $clog2(YELLOW_TIME+1);

    reg [1:0]      state, next_state;
    reg [TW-1:0]   timer;
    wire           timer_done = (timer == 0);

    // (1) state register
    always @(posedge clk) begin
        if (rst) state <= S_NS_GREEN;
        else     state <= next_state;
    end

    // timer (datapath) register: reloads on every state change, else counts down
    always @(posedge clk) begin
        if (rst)
            timer <= GREEN_TIME[TW-1:0] - 1'b1;
        else if (state != next_state) begin
            case (next_state)
                S_NS_GREEN, S_EW_GREEN: timer <= GREEN_TIME[TW-1:0]  - 1'b1;
                default:                timer <= YELLOW_TIME[TW-1:0] - 1'b1;
            endcase
        end else if (!timer_done) begin
            timer <= timer - 1'b1;
        end
    end

    // (2) next-state logic
    always @(*) begin
        case (state)
            S_NS_GREEN:  next_state = timer_done ? S_NS_YELLOW : S_NS_GREEN;
            S_NS_YELLOW: next_state = timer_done ? S_EW_GREEN  : S_NS_YELLOW;
            S_EW_GREEN:  next_state = timer_done ? S_EW_YELLOW : S_EW_GREEN;
            S_EW_YELLOW: next_state = timer_done ? S_NS_GREEN  : S_EW_YELLOW;
            default:     next_state = S_NS_GREEN;
        endcase
    end

    // (3) output logic (Moore)
    always @(*) begin
        case (state)
            S_NS_GREEN:  begin ns_light = 2'b10; ew_light = 2'b00; end
            S_NS_YELLOW: begin ns_light = 2'b01; ew_light = 2'b00; end
            S_EW_GREEN:  begin ns_light = 2'b00; ew_light = 2'b10; end
            S_EW_YELLOW: begin ns_light = 2'b00; ew_light = 2'b01; end
            default:     begin ns_light = 2'b00; ew_light = 2'b00; end
        endcase
    end

endmodule
