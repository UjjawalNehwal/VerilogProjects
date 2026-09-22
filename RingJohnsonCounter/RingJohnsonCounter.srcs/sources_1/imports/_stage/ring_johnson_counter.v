`timescale 1ns / 1ps
//=============================================================================
// Ring Counter
//   - Single hot bit circulates: 0001 -> 0010 -> 0100 -> 1000 -> 0001 ...
//   - Period = WIDTH states
//=============================================================================
module ring_counter #(
    parameter integer WIDTH = 4
)(
    input  wire              clk,
    input  wire              rst,   // synchronous, active-high
    output reg  [WIDTH-1:0]  q
);

    always @(posedge clk) begin
        if (rst)
            q <= {{(WIDTH-1){1'b0}}, 1'b1};
        else
            q <= {q[WIDTH-2:0], q[WIDTH-1]};
    end

endmodule


//=============================================================================
// Johnson Counter (twisted-ring counter)
//   - Complement of MSB fed back into LSB: 0000 -> 1000 -> 1100 -> 1110 ->
//     1111 -> 0111 -> 0011 -> 0001 -> 0000 ...
//   - Period = 2*WIDTH states
//=============================================================================
module johnson_counter #(
    parameter integer WIDTH = 4
)(
    input  wire              clk,
    input  wire              rst,   // synchronous, active-high
    output reg  [WIDTH-1:0]  q
);

    always @(posedge clk) begin
        if (rst)
            q <= {WIDTH{1'b0}};
        else
            q <= {q[WIDTH-2:0], ~q[WIDTH-1]};
    end

endmodule
