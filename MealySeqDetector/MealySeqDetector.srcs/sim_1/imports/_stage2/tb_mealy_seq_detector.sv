`timescale 1ns / 1ps
module tb_mealy_seq_detector;

    reg clk = 0, rst, din;
    wire detected_ov, detected_no;

    integer errors = 0;
    integer i, n;
    reg [255:0] stream;   // bit stream applied, stream[i] applied at step i
    integer matches_ov, matches_no;

    mealy_seq_detector #(.OVERLAP(1)) dut_ov (
        .clk(clk), .rst(rst), .din(din), .detected(detected_ov)
    );
    mealy_seq_detector #(.OVERLAP(0)) dut_no (
        .clk(clk), .rst(rst), .din(din), .detected(detected_no)
    );

    always #5 clk = ~clk;   // 10ns period

    // reference model: reproduces expected overlap/non-overlap match counts
    // by scanning the same bit stream in software
    function integer count_matches(input [255:0] s, input integer len, input integer overlap);
        integer idx;
        integer got;
        reg [3:0] window;
        begin
            got = 0;
            window = 4'b0000;
            idx = 0;
            while (idx < len) begin
                window = {window[2:0], s[idx]};
                if (idx >= 3 && window == 4'b1001) begin
                    got = got + 1;
                    if (!overlap) window = 4'b0000; // discard history, restart search
                end
                idx = idx + 1;
            end
            count_matches = got;
        end
    endfunction

    // apply one bit and sample the Mealy output BEFORE the consuming edge
    // (state is still pre-transition when combined with the new din here)
    task apply_bit(input b);
        begin
            @(negedge clk);
            din = b;
            #4;                       // settle, still before next posedge
            if (detected_ov) matches_ov = matches_ov + 1;
            if (detected_no) matches_no = matches_no + 1;
            @(posedge clk);           // let the transition happen
        end
    endtask

    initial begin
        rst = 1; din = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;

        // deterministic stream exercising overlap ("1001001") and gaps
        stream = 256'b0;
        n = 20;
        stream[0]=1; stream[1]=0; stream[2]=0; stream[3]=1; stream[4]=0;
        stream[5]=0; stream[6]=1; stream[7]=1; stream[8]=0; stream[9]=0;
        stream[10]=1; stream[11]=0; stream[12]=0; stream[13]=1; stream[14]=0;
        stream[15]=0; stream[16]=1; stream[17]=0; stream[18]=1; stream[19]=1;

        matches_ov = 0; matches_no = 0;
        for (i = 0; i < n; i = i + 1)
            apply_bit(stream[i]);

        if (matches_ov !== count_matches(stream, n, 1)) begin
            $display("FAIL overlap match count: expected=%0d got=%0d", count_matches(stream, n, 1), matches_ov);
            errors = errors + 1;
        end
        if (matches_no !== count_matches(stream, n, 0)) begin
            $display("FAIL non-overlap match count: expected=%0d got=%0d", count_matches(stream, n, 0), matches_no);
            errors = errors + 1;
        end

        // explicit spot check: "1001001" (7 bits) must give 2 overlapping
        // matches but only 1 non-overlapping match
        rst = 1; @(negedge clk); rst = 0;
        matches_ov = 0; matches_no = 0;
        begin : spot_check
            reg [6:0] pat;
            pat = 7'b1001001;
            for (i = 6; i >= 0; i = i - 1)
                apply_bit(pat[i]);
        end
        if (matches_ov !== 2) begin
            $display("FAIL spot-check overlap: expected=2 got=%0d", matches_ov);
            errors = errors + 1;
        end
        if (matches_no !== 1) begin
            $display("FAIL spot-check non-overlap: expected=1 got=%0d", matches_no);
            errors = errors + 1;
        end

        if (errors == 0) $display("TEST PASSED: mealy_seq_detector");
        else $display("TEST FAILED: mealy_seq_detector (%0d errors)", errors);
        $finish;
    end

    initial begin
        #5000;
        $display("FAIL: mealy_seq_detector testbench timeout");
        $finish;
    end

endmodule
