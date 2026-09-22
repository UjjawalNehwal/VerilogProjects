`timescale 1ns / 1ps
//=============================================================================
// Vending Machine FSM - multiple coin denominations + change
//   coin_sel: 00 = 5 cents, 01 = 10 cents, 10 = 25 cents
//   coin_in pulses for one cycle per coin inserted.
//   When accumulated credit >= PRICE, machine dispenses for one cycle and
//   returns (credit - PRICE) as change, then resets credit to 0.
//=============================================================================
module vending_machine #(
    parameter integer PRICE = 30   // cents
)(
    input  wire       clk,
    input  wire       rst,        // synchronous, active-high
    input  wire       coin_in,
    input  wire [1:0] coin_sel,
    output reg         dispense,
    output reg  [7:0]  change,
    output wire [7:0]  credit
);

    localparam S_IDLE = 1'b0, S_DISPENSE = 1'b1;

    reg       state, next_state;
    reg [7:0] total, next_total;

    wire [7:0] coin_val = (coin_sel == 2'b00) ? 8'd5  :
                           (coin_sel == 2'b01) ? 8'd10 : 8'd25;

    assign credit = total;

    // (1) state register
    always @(posedge clk) begin
        if (rst) state <= S_IDLE;
        else     state <= next_state;
    end

    // credit (datapath) register
    always @(posedge clk) begin
        if (rst) total <= 8'd0;
        else     total <= next_total;
    end

    // (2) next-state + next-total logic
    always @(*) begin
        next_state = state;
        next_total = total;
        case (state)
            S_IDLE: begin
                if (coin_in) begin
                    next_total = total + coin_val;
                    if ((total + coin_val) >= PRICE)
                        next_state = S_DISPENSE;
                end
            end
            S_DISPENSE: begin
                next_total = 8'd0;
                next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // (3) output logic
    always @(*) begin
        dispense = (state == S_DISPENSE);
        change   = (state == S_DISPENSE) ? (total - PRICE) : 8'd0;
    end

endmodule
