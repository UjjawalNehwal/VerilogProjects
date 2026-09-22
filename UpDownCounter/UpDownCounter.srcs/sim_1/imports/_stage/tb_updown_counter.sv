`timescale 1ns / 1ps
module tb_updown_counter;

    localparam integer WIDTH = 8;

    reg clk = 0, rst, en, up_down;
    wire [WIDTH-1:0] count;

    reg [WIDTH-1:0] expected;
    integer errors = 0;
    integer i;

    updown_counter #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst(rst), .en(en), .up_down(up_down), .count(count)
    );

    always #5 clk = ~clk;

    task check(input string msg);
        begin
            if (count !== expected) begin
                $display("FAIL [%0t] %s : expected=%0d got=%0d", $time, msg, expected, count);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        rst = 1; en = 0; up_down = 1; expected = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;
        @(posedge clk); #1; check("post-reset");

        // count up including 8-bit overflow wrap
        en = 1; up_down = 1;
        for (i = 0; i < 300; i = i + 1) begin
            @(posedge clk); #1;
            expected = expected + 1'b1;
            check("count up");
        end

        // count down including underflow wrap
        up_down = 0;
        for (i = 0; i < 300; i = i + 1) begin
            @(posedge clk); #1;
            expected = expected - 1'b1;
            check("count down");
        end

        // enable=0 holds value
        en = 0;
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk); #1;
            check("hold on en=0");
        end

        // reset mid-run
        @(negedge clk); rst = 1;
        @(posedge clk); #1; expected = 0; check("reset mid-run");
        rst = 0;

        if (errors == 0) $display("TEST PASSED: updown_counter");
        else $display("TEST FAILED: updown_counter (%0d errors)", errors);
        $finish;
    end

    initial begin
        #10000;
        $display("FAIL: updown_counter testbench timeout");
        $finish;
    end

endmodule
