`timescale 1ns / 1ps
module tb_lfsr_prng;

    localparam integer WIDTH = 8;
    localparam [WIDTH-1:0] TAPS = 8'hB8;

    reg clk = 0, rst, en, load;
    reg [WIDTH-1:0] seed;
    wire [WIDTH-1:0] lfsr_out;

    integer errors = 0;
    integer i;
    reg [WIDTH-1:0] shadow;
    reg [WIDTH-1:0] seen [0:255];
    integer seen_count;
    reg found_dup;
    integer j;

    lfsr_prng #(.WIDTH(WIDTH), .TAPS(TAPS)) dut (
        .clk(clk), .rst(rst), .en(en), .load(load), .seed(seed), .lfsr_out(lfsr_out)
    );

    always #5 clk = ~clk;

    function [WIDTH-1:0] next_state(input [WIDTH-1:0] s);
        reg fb;
        begin
            fb = ^(s & TAPS);
            next_state = {s[WIDTH-2:0], fb};
        end
    endfunction

    initial begin
        rst = 1; en = 0; load = 0; seed = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;
        if (lfsr_out !== 8'hFF) begin
            $display("FAIL [%0t] reset value expected FF got %h", $time, lfsr_out);
            errors = errors + 1;
        end
        shadow = 8'hFF;

        // never gets stuck at all-zero, and matches reference model, for a
        // full period of 255 shifts (maximal-length polynomial)
        en = 1;
        seen_count = 0;
        for (i = 0; i < 255; i = i + 1) begin
            @(posedge clk); #1;
            shadow = next_state(shadow);
            if (lfsr_out !== shadow) begin
                $display("FAIL [%0t] step %0d expected=%h got=%h", $time, i, shadow, lfsr_out);
                errors = errors + 1;
            end
            if (lfsr_out == 8'h00) begin
                $display("FAIL [%0t] LFSR locked at all-zero state", $time);
                errors = errors + 1;
            end
            seen[seen_count] = lfsr_out;
            seen_count = seen_count + 1;
        end

        // after 255 steps from seed FF, a maximal LFSR must return to FF
        if (lfsr_out !== 8'hFF) begin
            $display("FAIL [%0t] period != 255, expected return to FF, got=%h", $time, lfsr_out);
            errors = errors + 1;
        end

        // spot-check uniqueness across the captured period (O(n^2), n=255 is fine)
        found_dup = 0;
        for (i = 0; i < seen_count; i = i + 1) begin
            for (j = i+1; j < seen_count; j = j + 1) begin
                if (seen[i] == seen[j]) found_dup = 1;
            end
        end
        if (found_dup) begin
            $display("FAIL: duplicate states found within one claimed period");
            errors = errors + 1;
        end

        // load with zero seed must be guarded to all-ones
        @(negedge clk); load = 1; seed = 8'h00;
        @(posedge clk); #1;
        if (lfsr_out !== 8'hFF) begin
            $display("FAIL [%0t] zero-seed load not guarded, got=%h", $time, lfsr_out);
            errors = errors + 1;
        end
        @(negedge clk); load = 0;

        // normal seed load
        @(negedge clk); load = 1; seed = 8'h4C;
        @(posedge clk); #1;
        if (lfsr_out !== 8'h4C) begin
            $display("FAIL [%0t] seed load mismatch, got=%h", $time, lfsr_out);
            errors = errors + 1;
        end
        @(negedge clk); load = 0;

        if (errors == 0) $display("TEST PASSED: lfsr_prng");
        else $display("TEST FAILED: lfsr_prng (%0d errors)", errors);
        $finish;
    end

    initial begin
        #10000;
        $display("FAIL: lfsr_prng testbench timeout");
        $finish;
    end

endmodule
