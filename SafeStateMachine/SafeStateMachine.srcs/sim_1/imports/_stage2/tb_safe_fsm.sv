`timescale 1ns / 1ps
module tb_safe_fsm;

    reg clk = 0, rst, go;
    wire [3:0] state_out;
    wire fault_detected;

    integer errors = 0;
    integer i;

    localparam [3:0] S0 = 4'b0001, S1 = 4'b0010, S2 = 4'b0100, S3 = 4'b1000;

    safe_fsm dut (
        .clk(clk), .rst(rst), .go(go),
        .state_out(state_out), .fault_detected(fault_detected)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 1; go = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;

        if (state_out !== S0) begin
            $display("FAIL post-reset state: expected S0 got=%b", state_out);
            errors = errors + 1;
        end

        // normal cycle: S0 -[go]-> S1 -> S2 -> S3 -> S0 (repeat twice)
        for (i = 0; i < 2; i = i + 1) begin
            @(negedge clk); go = 1'b1;
            @(posedge clk); #1;
            if (state_out !== S1) begin $display("FAIL expected S1 got=%b", state_out); errors=errors+1; end
            @(negedge clk); go = 1'b0;
            @(posedge clk); #1;
            if (state_out !== S2) begin $display("FAIL expected S2 got=%b", state_out); errors=errors+1; end
            @(posedge clk); #1;
            if (state_out !== S3) begin $display("FAIL expected S3 got=%b", state_out); errors=errors+1; end
            @(posedge clk); #1;
            if (state_out !== S0) begin $display("FAIL expected S0 (wrap) got=%b", state_out); errors=errors+1; end
            if (fault_detected !== 1'b0) begin
                $display("FAIL spurious fault_detected during normal operation");
                errors = errors + 1;
            end
        end

        // fault injection: force the state register into an illegal
        // (non-one-hot) code, then verify the FSM catches it and recovers
        // to S0 on the very next clock, with fault_detected asserted
        // during the illegal cycle.
        @(negedge clk);
        force dut.state = 4'b0011;   // illegal: two-hot
        #1;
        if (fault_detected !== 1'b1) begin
            $display("FAIL: fault_detected not asserted for illegal state 0011");
            errors = errors + 1;
        end
        release dut.state;   // release BEFORE the recovering edge, so the
                              // clocked state<=next_state write can land
        @(posedge clk); #1;
        if (state_out !== S0) begin
            $display("FAIL: did not recover to S0 after illegal state, got=%b", state_out);
            errors = errors + 1;
        end
        if (fault_detected !== 1'b0) begin
            $display("FAIL: fault_detected still asserted after recovery");
            errors = errors + 1;
        end

        // second fault: all-zero (no-hot) illegal code
        @(negedge clk);
        force dut.state = 4'b0000;
        #1;
        if (fault_detected !== 1'b1) begin
            $display("FAIL: fault_detected not asserted for illegal state 0000");
            errors = errors + 1;
        end
        release dut.state;
        @(posedge clk); #1;
        if (state_out !== S0) begin
            $display("FAIL: did not recover to S0 after all-zero fault, got=%b", state_out);
            errors = errors + 1;
        end

        // confirm normal operation resumes cleanly after recovery
        @(negedge clk); go = 1'b1;
        @(posedge clk); #1;
        if (state_out !== S1) begin
            $display("FAIL: normal operation did not resume after fault recovery, got=%b", state_out);
            errors = errors + 1;
        end

        if (errors == 0) $display("TEST PASSED: safe_fsm");
        else $display("TEST FAILED: safe_fsm (%0d errors)", errors);
        $finish;
    end

    initial begin
        #5000;
        $display("FAIL: safe_fsm testbench timeout");
        $finish;
    end

endmodule
