`timescale 1ns / 1ps
module tb_universal_shift_reg;

    localparam integer WIDTH = 8;

    reg clk = 0, rst;
    reg [1:0] mode;
    reg sin_r, sin_l;
    reg [WIDTH-1:0] pin;
    wire [WIDTH-1:0] q;

    integer errors = 0;
    integer i;
    reg [WIDTH-1:0] shadow;

    universal_shift_reg #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst(rst), .mode(mode),
        .sin_r(sin_r), .sin_l(sin_l), .pin(pin), .q(q)
    );

    always #5 clk = ~clk;

    task check(input [WIDTH-1:0] exp, input string msg);
        begin
            if (q !== exp) begin
                $display("FAIL [%0t] %s : expected=%b got=%b", $time, msg, exp, q);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        rst = 1; mode = 2'b00; sin_r = 0; sin_l = 0; pin = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;
        check(8'h00, "post-reset");

        // PIPO: parallel load
        @(negedge clk); mode = 2'b11; pin = 8'hA5;
        @(posedge clk); #1;
        check(8'hA5, "parallel load (PIPO)");

        // hold
        @(negedge clk); mode = 2'b00;
        @(posedge clk); #1;
        check(8'hA5, "hold");

        // PISO: shift right, serial out observed at q[0], feed zeros in
        @(negedge clk); mode = 2'b01; sin_r = 0;
        shadow = 8'hA5;
        for (i = 0; i < WIDTH; i = i + 1) begin
            @(posedge clk); #1;
            shadow = {1'b0, shadow[WIDTH-1:1]};
            check(shadow, "shift right (PISO)");
        end
        check(8'h00, "shift right fully drained");

        // SIPO: shift in a known pattern serially (right), MSB-first feed
        // pattern to load (MSB first): 1,1,0,0,1,0,1,1 -> should end up as
        // q = 8'b1100_1011 after 8 shifts (first bit shifted in ends at MSB)
        @(negedge clk); mode = 2'b01;
        begin : sipo_block
            reg [WIDTH-1:0] pattern;
            pattern = 8'b1100_1011;
            shadow = 8'h00;
            for (i = WIDTH-1; i >= 0; i = i - 1) begin
                sin_r = pattern[i];
                @(posedge clk); #1;
                shadow = {sin_r, shadow[WIDTH-1:1]};
                check(shadow, "shift right (SIPO load)");
            end
        end
        check(shadow, "SIPO final value");

        // shift left, serial in at LSB
        @(negedge clk); mode = 2'b10; sin_l = 1'b1;
        shadow = q;
        @(posedge clk); #1;
        shadow = {shadow[WIDTH-2:0], 1'b1};
        check(shadow, "shift left");

        @(negedge clk); sin_l = 1'b0;
        @(posedge clk); #1;
        shadow = {shadow[WIDTH-2:0], 1'b0};
        check(shadow, "shift left again");

        if (errors == 0) $display("TEST PASSED: universal_shift_reg");
        else $display("TEST FAILED: universal_shift_reg (%0d errors)", errors);
        $finish;
    end

    initial begin
        #5000;
        $display("FAIL: universal_shift_reg testbench timeout");
        $finish;
    end

endmodule
