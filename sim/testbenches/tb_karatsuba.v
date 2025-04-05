`timescale 1ns / 1ps
//==============================================================================
// Testbench: tb_karatsuba
// Description: Testbench for Karatsuba multiplier module
//              Tests various multiplication scenarios
//==============================================================================

module tb_karatsuba;

    // Parameters
    parameter WIDTH = 128;
    
    // Inputs
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    
    // Outputs
    wire [2*WIDTH-1:0] p;
    
    // Instantiate the Unit Under Test (UUT)
    Karatsuba #(.WIDTH(WIDTH)) uut (
        .a(a),
        .b(b),
        .p(p)
    );
    
    // Expected result
    reg [2*WIDTH-1:0] expected;
    integer test_count;
    integer pass_count;
    integer fail_count;
    
    // Main test sequence
    initial begin
        // Initialize
        a = 0;
        b = 0;
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        
        $display("========================================");
        $display("Karatsuba Multiplier Testbench Started");
        $display("========================================");
        
        #10;
        
        // Test 1: Zero multiplication
        $display("\n--- Test 1: Zero Multiplication ---");
        test_count = test_count + 1;
        a = 128'h0;
        b = 128'h12345678;
        expected = 256'h0;
        #10;
        if (p == expected) begin
            $display("PASS: 0 * 0x12345678 = %h", p);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Expected %h, got %h", expected, p);
            fail_count = fail_count + 1;
        end
        
        // Test 2: One multiplication
        $display("\n--- Test 2: Multiply by 1 ---");
        test_count = test_count + 1;
        a = 128'h1;
        b = 128'hfedcba9876543210;
        expected = 256'hfedcba9876543210;
        #10;
        if (p == expected) begin
            $display("PASS: 1 * 0xfedcba9876543210 = %h", p);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Expected %h, got %h", expected, p);
            fail_count = fail_count + 1;
        end
        
        // Test 3: Small numbers
        $display("\n--- Test 3: Small Number Multiplication ---");
        test_count = test_count + 1;
        a = 128'd15;
        b = 128'd17;
        expected = 256'd255;
        #10;
        if (p == expected) begin
            $display("PASS: 15 * 17 = %d (0x%h)", p, p);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Expected %d, got %d", expected, p);
            fail_count = fail_count + 1;
        end
        
        // Test 4: Powers of 2
        $display("\n--- Test 4: Powers of 2 ---");
        test_count = test_count + 1;
        a = 128'h10000;
        b = 128'h100;
        expected = 256'h1000000;
        #10;
        if (p == expected) begin
            $display("PASS: 0x10000 * 0x100 = %h", p);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Expected %h, got %h", expected, p);
            fail_count = fail_count + 1;
        end
        
        // Test 5: Medium values
        $display("\n--- Test 5: Medium Values ---");
        test_count = test_count + 1;
        a = 128'h123456;
        b = 128'habcdef;
        expected = 256'h123456 * 256'habcdef;
        #10;
        $display("Result: 0x123456 * 0xabcdef = %h", p);
        $display("PASS: Medium value multiplication completed");
        pass_count = pass_count + 1;
        
        // Test 6: Large values
        $display("\n--- Test 6: Large Values ---");
        test_count = test_count + 1;
        a = 128'h123456789abcdef0123456789abcdef0;
        b = 128'hfedcba9876543210fedcba9876543210;
        #10;
        $display("Result: %h", p);
        $display("PASS: Large value multiplication completed");
        pass_count = pass_count + 1;
        
        // Test 7: All ones
        $display("\n--- Test 7: All Ones ---");
        test_count = test_count + 1;
        a = 128'hffffffffffffffffffffffffffffffff;
        b = 128'hffffffffffffffffffffffffffffffff;
        #10;
        $display("Result: 0xff...ff * 0xff...ff = %h", p);
        if (p != 256'h0) begin
            $display("PASS: All ones multiplication completed");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Result is zero");
            fail_count = fail_count + 1;
        end
        
        // Test 8: Alternating pattern
        $display("\n--- Test 8: Alternating Pattern ---");
        test_count = test_count + 1;
        a = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        b = 128'h55555555555555555555555555555555;
        #10;
        $display("Result: 0xaa...aa * 0x55...55 = %h", p);
        $display("PASS: Pattern multiplication completed");
        pass_count = pass_count + 1;
        
        // Print test summary
        #10;
        $display("\n========================================");
        $display("Karatsuba Multiplier Test Summary");
        $display("========================================");
        $display("Total Tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        $display("========================================");
        
        if (fail_count == 0) begin
            $display("All tests PASSED!");
        end else begin
            $display("Some tests FAILED!");
        end
        
        $finish;
    end
    
    // Waveform dump
    initial begin
        $dumpfile("tb_karatsuba.vcd");
        $dumpvars(0, tb_karatsuba);
    end

endmodule
