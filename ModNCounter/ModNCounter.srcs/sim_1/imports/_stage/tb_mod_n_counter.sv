`timescale 1ns / 1ps
module tb_mod_n_counter;

    localparam integer N     = 10;
    localparam integer WIDTH = 4;

    reg clk = 0, rst, en, load;
    reg [WIDTH-1:0] load_val;
    wire [WIDTH-1:0] count;
    wire tc;

    integer errors = 0;
    integer i;

    mod_n_counter #(.N(N), .WIDTH(WIDTH)) dut (
        .clk(clk), .rst(rst), .en(en), .load(load),
        .load_val(load_val), .count(count), .tc(tc)
    );

    always #5 clk = ~clk;

    task check(input [WIDTH-1:0] exp_count, input string msg);
        begin
            if (count !== exp_count) begin
                $display("FAIL [%0t] %s : expected count=%0d got=%0d", $time, msg, exp_count, count);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        rst = 1; en = 0; load = 0; load_val = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;
        check(0, "post-reset");

        // free-run and check wraparound at N-1 -> 0
        en = 1;
        for (i = 1; i <= 2*N; i = i + 1) begin
            @(posedge clk); #1;
            check(i % N, "free-run count");
            if (count == N-1 && !tc) begin
                $display("FAIL [%0t] tc not asserted at count=N-1", $time);
                errors = errors + 1;
            end
        end

        // disable enable, verify hold
        en = 0;
        @(negedge clk); load_val[WIDTH-1:0] = count;
        @(posedge clk); #1;
        check(load_val, "enable=0 hold");

        // synchronous load, priority over enable
        en = 1;
        @(negedge clk);
        load = 1; load_val = 4'd7;
        @(posedge clk); #1;
        check(4'd7, "synchronous load");
        @(negedge clk); load = 0;

        // continue counting from loaded value
        @(posedge clk); #1;
        check(4'd8, "count after load");

        // synchronous reset while enabled
        @(negedge clk); rst = 1;
        @(posedge clk); #1;
        check(0, "sync reset while running");
        rst = 0;

        if (errors == 0) $display("TEST PASSED: mod_n_counter");
        else $display("TEST FAILED: mod_n_counter (%0d errors)", errors);
        $finish;
    end

    initial begin
        #2000;
        $display("FAIL: mod_n_counter testbench timeout");
        $finish;
    end

endmodule
