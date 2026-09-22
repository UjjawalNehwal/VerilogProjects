`timescale 1ns / 1ps
//=============================================================================
// Universal Shift Register (SISO, SIPO, PISO, PIPO)
//   mode = 00 : hold
//   mode = 01 : shift right  (new bit sin_r enters MSB, q[0] is serial out)
//   mode = 10 : shift left   (new bit sin_l enters LSB, q[WIDTH-1] is serial out)
//   mode = 11 : parallel load (PIPO)
//
//   Usage as each classic topology:
//     SISO : mode=01 continuously, read serial data at q[0]
//     SIPO : mode=01 continuously, read parallel data at q after WIDTH shifts
//     PISO : mode=11 once to load pin, then mode=01/10, read serial out bit
//     PIPO : mode=11, read q same cycle data is valid
//=============================================================================
module universal_shift_reg #(
    parameter integer WIDTH = 8
)(
    input  wire                 clk,
    input  wire                 rst,     // synchronous, active-high
    input  wire [1:0]           mode,
    input  wire                 sin_r,   // serial in, shift-right direction
    input  wire                 sin_l,   // serial in, shift-left direction
    input  wire [WIDTH-1:0]     pin,     // parallel in
    output reg  [WIDTH-1:0]     q        // parallel out / serial out at q[0] or q[WIDTH-1]
);

    always @(posedge clk) begin
        if (rst)
            q <= {WIDTH{1'b0}};
        else begin
            case (mode)
                2'b00: q <= q;                              // hold
                2'b01: q <= {sin_r, q[WIDTH-1:1]};           // shift right
                2'b10: q <= {q[WIDTH-2:0], sin_l};           // shift left
                2'b11: q <= pin;                             // parallel load
            endcase
        end
    end

endmodule
