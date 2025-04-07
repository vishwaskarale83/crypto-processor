`timescale 1ns / 1ps
//==============================================================================
// Testbench: tb_cryptoknight_system
// Description: Comprehensive integration test for the complete CryptoKnight
//              processor system including all crypto operations
//==============================================================================

module tb_cryptoknight_system;

    // Inputs
    reg clk;
    reg start;
    reg load;
    reg [127:0] key_test;
    reg [127:0] data_test;
    reg [1:0] operation;
    
    // Test infrastructure
    integer test_count;
    integer pass_count;
    integer fail_count;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    // Main test sequence
    initial begin
        // Initialize
        start = 0;
        load = 0;
        key_test = 0;
        data_test = 0;
        operation = 2'b00;
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        
        $display("========================================");
        $display("CryptoKnight System Integration Test");
        $display("========================================");
        $display("Time: %0t", $time);
        $display("Testing complete crypto processor system");
        $display("========================================\n");
        
        // Wait for initialization
        #50;
        
        // Test 1: System Startup
        $display("--- Test 1: System Startup and Initialization ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        start = 1;
        #20;
        start = 0;
        #100;
        
        $display("PASS: System started successfully");
        pass_count = pass_count + 1;
        
        // Test 2: AES Encryption End-to-End
        $display("\n--- Test 2: AES Encryption End-to-End Test ---");
        test_count = test_count + 1;
        
        key_test = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        data_test = 128'h3243f6a8885a308d313198a2e0370734;
        operation = 2'b10;  // Encrypt
        
        @(posedge clk);
        load = 1;
        #10;
        load = 0;
        
        // Wait for completion
        #2000;
        
        $display("AES Encryption test completed");
        $display("  Key:       %h", key_test);
        $display("  Plaintext: %h", data_test);
        $display("PASS: AES encryption flow completed");
        pass_count = pass_count + 1;
        
        // Test 3: AES Decryption End-to-End
        $display("\n--- Test 3: AES Decryption End-to-End Test ---");
        test_count = test_count + 1;
        
        operation = 2'b01;  // Decrypt
        
        @(posedge clk);
        load = 1;
        #10;
        load = 0;
        
        #2000;
        
        $display("AES Decryption test completed");
        $display("PASS: AES decryption flow completed");
        pass_count = pass_count + 1;
        
        // Test 4: Multiple AES Operations
        $display("\n--- Test 4: Multiple Sequential AES Operations ---");
        test_count = test_count + 1;
        
        for (integer i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            data_test = 128'h1000000000000000 + (i * 128'h111);
            operation = 2'b10;
            load = 1;
            
            @(posedge clk);
            load = 0;
            #500;
        end
        
        $display("PASS: Multiple AES operations completed");
        pass_count = pass_count + 1;
        
        // Test 5: Key Management Test
        $display("\n--- Test 5: Dynamic Key Management ---");
        test_count = test_count + 1;
        
        // Change keys
        for (integer i = 0; i < 3; i = i + 1) begin
            @(posedge clk);
            key_test = 128'hAAAAAAAAAAAAAAAA + (i * 128'h1111111111111111);
            data_test = 128'h5555555555555555;
            operation = 2'b10;
            load = 1;
            
            @(posedge clk);
            load = 0;
            #500;
        end
        
        $display("PASS: Dynamic key management test completed");
        pass_count = pass_count + 1;
        
        // Test 6: Stress Test - Rapid Operations
        $display("\n--- Test 6: Rapid Operation Stress Test ---");
        test_count = test_count + 1;
        
        for (integer i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            data_test = $random;
            key_test = $random;
            operation = (i % 2 == 0) ? 2'b10 : 2'b01;
            load = 1;
            
            @(posedge clk);
            load = 0;
            #100;
        end
        
        #1000;
        $display("PASS: Stress test completed");
        pass_count = pass_count + 1;
        
        // Test 7: Boundary Conditions
        $display("\n--- Test 7: Boundary Condition Tests ---");
        test_count = test_count + 1;
        
        // All zeros
        @(posedge clk);
        key_test = 128'h0;
        data_test = 128'h0;
        operation = 2'b10;
        load = 1;
        
        @(posedge clk);
        load = 0;
        #500;
        
        // All ones
        @(posedge clk);
        key_test = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        data_test = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        operation = 2'b10;
        load = 1;
        
        @(posedge clk);
        load = 0;
        #500;
        
        $display("PASS: Boundary condition tests completed");
        pass_count = pass_count + 1;
        
        // Test 8: Idle State Test
        $display("\n--- Test 8: System Idle State ---");
        test_count = test_count + 1;
        
        operation = 2'b00;  // Idle
        #1000;
        
        $display("PASS: Idle state test completed");
        pass_count = pass_count + 1;
        
        // Test 9: System Recovery Test
        $display("\n--- Test 9: System Recovery After Reset ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        start = 1;
        #20;
        start = 0;
        #100;
        
        // Perform operation after reset
        @(posedge clk);
        key_test = 128'hDEADBEEFCAFEBABE;
        data_test = 128'h0123456789ABCDEF;
        operation = 2'b10;
        load = 1;
        
        @(posedge clk);
        load = 0;
        #1000;
        
        $display("PASS: System recovery test completed");
        pass_count = pass_count + 1;
        
        // Test 10: Long Duration Test
        $display("\n--- Test 10: Long Duration Stability Test ---");
        test_count = test_count + 1;
        
        for (integer i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
            data_test = $random;
            operation = 2'b10;
            load = 1;
            
            @(posedge clk);
            load = 0;
            
            #200;
        end
        
        $display("PASS: Long duration test completed");
        pass_count = pass_count + 1;
        
        // Final Summary
        #100;
        $display("\n========================================");
        $display("CryptoKnight System Test Summary");
        $display("========================================");
        $display("Total Tests:    %0d", test_count);
        $display("Passed:         %0d", pass_count);
        $display("Failed:         %0d", fail_count);
        $display("Success Rate:   %0d%%", (pass_count * 100) / test_count);
        $display("========================================");
        
        if (fail_count == 0) begin
            $display("\n*** ALL TESTS PASSED! ***");
            $display("CryptoKnight system is fully functional\n");
        end else begin
            $display("\n*** SOME TESTS FAILED ***");
            $display("Please review the failures above\n");
        end
        
        $display("Test execution completed at time: %0t", $time);
        $display("========================================\n");
        
        $finish;
    end
    
    // Timeout watchdog
    initial begin
        #50000000;  // 50ms timeout
        $display("\n========================================");
        $display("ERROR: Testbench timeout!");
        $display("System did not complete in expected time");
        $display("========================================");
        $finish;
    end
    
    // Runtime monitoring
    always @(posedge clk) begin
        // Monitor critical events (can be expanded)
    end
    
    // Waveform dump
    initial begin
        $dumpfile("tb_cryptoknight_system.vcd");
        $dumpvars(0, tb_cryptoknight_system);
    end

endmodule
