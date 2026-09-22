`timescale 1ns / 1ps
//=============================================================================
// Serial Adder FSM
//   Adds two WIDTH-bit operands one bit at a time (LSB first) through a
//   single full-adder bit-slice, controlled by an IDLE -> ADD -> DONE FSM.
//   sum is WIDTH bits (mod 2**WIDTH); cout is the final carry-out.
//=============================================================================
module serial_adder #(
    parameter integer WIDTH = 8
)(
    input  wire              clk,
    input  wire              rst,     // synchronous, active-high
    input  wire              start,
    input  wire [WIDTH-1:0]  a,
    input  wire [WIDTH-1:0]  b,
    output reg  [WIDTH-1:0]  sum,
    output reg               cout,
    output reg               done
);

    localparam [1:0] S_IDLE = 2'd0,
                      S_ADD  = 2'd1,
                      S_DONE = 2'd2;

    localparam integer CW = $clog2(WIDTH+1);

    reg [1:0]        state, next_state;
    reg [WIDTH-1:0]  areg, breg, sumreg;
    reg [CW-1:0]     bitcnt;
    reg              carry;

    wire a_bit      = areg[0];
    wire b_bit      = breg[0];
    wire sum_bit    = a_bit ^ b_bit ^ carry;
    wire carry_next = (a_bit & b_bit) | (carry & (a_bit ^ b_bit));

    // (1) state register
    always @(posedge clk) begin
        if (rst) state <= S_IDLE;
        else     state <= next_state;
    end

    // datapath registers
    always @(posedge clk) begin
        if (rst) begin
            areg <= {WIDTH{1'b0}};
            breg <= {WIDTH{1'b0}};
            sumreg <= {WIDTH{1'b0}};
            bitcnt <= {CW{1'b0}};
            carry <= 1'b0;
        end else begin
            case (state)
                S_IDLE: if (start) begin
                    areg   <= a;
                    breg   <= b;
                    sumreg <= {WIDTH{1'b0}};
                    bitcnt <= {CW{1'b0}};
                    carry  <= 1'b0;
                end
                S_ADD: begin
                    sumreg <= {sum_bit, sumreg[WIDTH-1:1]};
                    areg   <= areg >> 1;
                    breg   <= breg >> 1;
                    carry  <= carry_next;
                    bitcnt <= bitcnt + 1'b1;
                end
                default: ;
            endcase
        end
    end

    // (2) next-state logic
    always @(*) begin
        case (state)
            S_IDLE: next_state = start ? S_ADD : S_IDLE;
            S_ADD:  next_state = (bitcnt == WIDTH-1) ? S_DONE : S_ADD;
            S_DONE: next_state = S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // (3) output logic
    always @(*) begin
        sum  = sumreg;
        cout = (state == S_DONE) ? carry : 1'b0;
        done = (state == S_DONE);
    end

endmodule
