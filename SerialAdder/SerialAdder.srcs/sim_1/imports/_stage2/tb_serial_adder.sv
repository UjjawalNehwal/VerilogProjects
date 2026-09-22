`timescale 1ns / 1ps
module tb_serial_adder;

    localparam integer WIDTH = 8;

    reg clk = 0, rst, start;
    reg [WIDTH-1:0] a, b;
    wire [WIDTH-1:0] sum;
    wire cout, done;

    integer errors = 0;
    integer i;
    reg [WIDTH:0] expected;   // WIDTH+1 bits to capture carry-out too

    serial_adder #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst(rst), .start(start), .a(a), .b(b),
        .sum(sum), .cout(cout), .done(done)
    );

    always #5 clk = ~clk;

    task run_add(input [WIDTH-1:0] av, input [WIDTH-1:0] bv);
        integer waited;
        begin
            @(negedge clk);
            a = av; b = bv; start = 1'b1;
            @(negedge clk);
            start = 1'b0;

            waited = 0;
            while (!done && waited < WIDTH + 5) begin
                @(posedge clk); #1;
                waited = waited + 1;
            end

            if (!done) begin
                $display("FAIL a=%0d b=%0d : never asserted done", av, bv);
                errors = errors + 1;
            end else begin
                expected = av + bv;
                if (sum !== expected[WIDTH-1:0]) begin
                    $display("FAIL a=%0d b=%0d : sum expected=%0d got=%0d", av, bv, expected[WIDTH-1:0], sum);
                    errors = errors + 1;
                end
                if (cout !== expected[WIDTH]) begin
                    $display("FAIL a=%0d b=%0d : cout expected=%0d got=%0d", av, bv, expected[WIDTH], cout);
                    errors = errors + 1;
                end
            end
            @(posedge clk); #1; // return to IDLE
        end
    endtask

    initial begin
        rst = 1; start = 0; a = 0; b = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;

        // directed corner cases
        run_add(8'd0, 8'd0);
        run_add(8'd255, 8'd1);      // wraps, cout=1
        run_add(8'd255, 8'd255);    // max + max
        run_add(8'd128, 8'd127);    // no carry
        run_add(8'd1, 8'd1);

        // random cases
        for (i = 0; i < 40; i = i + 1)
            run_add($random, $random);

        if (errors == 0) $display("TEST PASSED: serial_adder");
        else $display("TEST FAILED: serial_adder (%0d errors)", errors);
        $finish;
    end

    initial begin
        #50000;
        $display("FAIL: serial_adder testbench timeout");
        $finish;
    end

endmodule
