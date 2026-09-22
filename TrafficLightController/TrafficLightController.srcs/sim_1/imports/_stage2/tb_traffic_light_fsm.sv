`timescale 1ns / 1ps
module tb_traffic_light_fsm;

    localparam integer GREEN_TIME  = 6;
    localparam integer YELLOW_TIME = 2;

    reg clk = 0, rst;
    wire [1:0] ns_light, ew_light;

    integer errors = 0;
    integer i, run_len, held;
    reg [1:0] prev_ns, prev_ew;

    traffic_light_fsm #(.GREEN_TIME(GREEN_TIME), .YELLOW_TIME(YELLOW_TIME)) dut (
        .clk(clk), .rst(rst), .ns_light(ns_light), .ew_light(ew_light)
    );

    always #5 clk = ~clk;

    // expected sequence of (ns,ew,duration) states, in order, repeating
    localparam integer NSTATES = 4;
    reg [1:0] seq_ns [0:NSTATES-1];
    reg [1:0] seq_ew [0:NSTATES-1];
    integer   seq_dur [0:NSTATES-1];

    initial begin
        seq_ns[0]=2'b10; seq_ew[0]=2'b00; seq_dur[0]=GREEN_TIME;
        seq_ns[1]=2'b01; seq_ew[1]=2'b00; seq_dur[1]=YELLOW_TIME;
        seq_ns[2]=2'b00; seq_ew[2]=2'b10; seq_dur[2]=GREEN_TIME;
        seq_ns[3]=2'b00; seq_ew[3]=2'b01; seq_dur[3]=YELLOW_TIME;
    end

    initial begin
        rst = 1;
        repeat (2) @(negedge clk);
        rst = 0;
        #1;   // let post-reset combinational outputs settle; state is
              // already registered as NS_GREEN from the reset edges, so no
              // extra clock edge should be consumed before measuring

        // mutual exclusion check across a long free-run, plus sequence/timing check
        for (int s = 0; s < 3*NSTATES; s = s + 1) begin
            integer phase;
            phase = s % NSTATES;

            if (ns_light !== seq_ns[phase] || ew_light !== seq_ew[phase]) begin
                $display("FAIL [%0t] phase %0d: expected ns=%b ew=%b got ns=%b ew=%b",
                          $time, phase, seq_ns[phase], seq_ew[phase], ns_light, ew_light);
                errors = errors + 1;
            end

            // mutual exclusion: never both green, never both non-red simultaneously wrong combo
            if (ns_light == 2'b10 && ew_light != 2'b00) begin
                $display("FAIL [%0t] NS green while EW not red: ew=%b", $time, ew_light);
                errors = errors + 1;
            end
            if (ew_light == 2'b10 && ns_light != 2'b00) begin
                $display("FAIL [%0t] EW green while NS not red: ns=%b", $time, ns_light);
                errors = errors + 1;
            end

            // hold for exactly seq_dur[phase] cycles, then must change
            held = 0;
            prev_ns = ns_light; prev_ew = ew_light;
            while (ns_light === prev_ns && ew_light === prev_ew && held <= seq_dur[phase] + 2) begin
                @(posedge clk); #1;
                held = held + 1;
            end
            if (held !== seq_dur[phase]) begin
                $display("FAIL [%0t] phase %0d duration: expected=%0d got=%0d", $time, phase, seq_dur[phase], held);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("TEST PASSED: traffic_light_fsm");
        else $display("TEST FAILED: traffic_light_fsm (%0d errors)", errors);
        $finish;
    end

    initial begin
        #20000;
        $display("FAIL: traffic_light_fsm testbench timeout");
        $finish;
    end

endmodule
