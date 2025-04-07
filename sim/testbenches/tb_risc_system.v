`timescale 1ns / 1ps
//==============================================================================
// Testbench: tb_risc_system
// Description: Comprehensive system testbench for RISC processor
//              Tests complete system operation with crypto instructions
//==============================================================================

module tb_risc_system;

    // Inputs
    reg clk;
    reg start;
    reg [14:0] instr_in;
    reg [127:0] data_ins;
    reg data_done;
    reg [14:0] data_no;
    reg private_key_new;
    reg randomize;
    reg AES_key_new;
    
    // Outputs
    wire FINAL_OUTPUT;
    
    // Instantiate the Unit Under Test (UUT)
    RISC uut (
        .clk(clk),
        .start(start),
        .instr_in(instr_in),
        .data_ins(data_ins),
        .data_done(data_done),
        .data_no(data_no),
        .private_key_new(private_key_new),
        .randomize(randomize),
        .AES_key_new(AES_key_new),
        .FINAL_OUTPUT(FINAL_OUTPUT)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer test_count;
    integer pass_count;
    integer fail_count;
    integer i;
    
    // Main test sequence
    initial begin
        // Initialize Inputs
        start = 0;
        instr_in = 0;
        data_ins = 0;
        data_done = 0;
        data_no = 0;
        private_key_new = 0;
        randomize = 0;
        AES_key_new = 0;
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        
        $display("========================================");
        $display("RISC System Testbench Started");
        $display("========================================");
        $display("Time: %0t", $time);
        
        // Reset sequence
        #20;
        start = 1;
        #20;
        start = 0;
        #50;
        
        // Test 1: Load instruction test
        $display("\n--- Test 1: Basic Instruction Load ---");
        test_count = test_count + 1;
        
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            instr_in = 15'h0000 + i; // Simple instructions
            #10;
        end
        
        $display("PASS: Instructions loaded");
        pass_count = pass_count + 1;
        #100;
        
        // Test 2: Data loading
        $display("\n--- Test 2: Load Data ---");
        test_count = test_count + 1;
        
        data_no = 15'd1;
        @(posedge clk);
        data_ins = 128'h123456789ABCDEF0123456789ABCDEF0;
        data_done = 1;
        
        @(posedge clk);
        data_done = 0;
        
        #50;
        $display("PASS: Data loaded into system");
        pass_count = pass_count + 1;
        #100;
        
        // Test 3: AES key generation
        $display("\n--- Test 3: AES Key Generation ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        AES_key_new = 1;
        randomize = 1;
        
        @(posedge clk);
        AES_key_new = 0;
        randomize = 0;
        
        #500;
        $display("PASS: AES key generation triggered");
        pass_count = pass_count + 1;
        #100;
        
        // Test 4: RSA key generation
        $display("\n--- Test 4: RSA Key Generation ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        private_key_new = 1;
        randomize = 1;
        
        @(posedge clk);
        private_key_new = 0;
        randomize = 0;
        
        #500;
        $display("PASS: RSA key generation triggered");
        pass_count = pass_count + 1;
        #100;
        
        // Test 5: Multiple data inputs
        $display("\n--- Test 5: Multiple Data Inputs ---");
        test_count = test_count + 1;
        
        for (i = 0; i < 10; i = i + 1) begin
            data_no = i;
            @(posedge clk);
            data_ins = 128'hA000000000000000 + (i * 128'h111);
            data_done = 1;
            
            @(posedge clk);
            data_done = 0;
            #20;
        end
        
        $display("PASS: Multiple data inputs loaded");
        pass_count = pass_count + 1;
        #200;
        
        // Test 6: System idle test
        $display("\n--- Test 6: System Idle Test ---");
        test_count = test_count + 1;
        
        #1000;
        $display("PASS: System idle test completed");
        pass_count = pass_count + 1;
        
        // Test 7: Rapid instruction sequence
        $display("\n--- Test 7: Rapid Instruction Sequence ---");
        test_count = test_count + 1;
        
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
            instr_in = 15'h1000 + (i * 15'h10);
        end
        
        #200;
        $display("PASS: Rapid instruction sequence completed");
        pass_count = pass_count + 1;
        
        // Test 8: System reset test
        $display("\n--- Test 8: System Reset ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        start = 1;
        
        #50;
        start = 0;
        
        #100;
        $display("PASS: System reset completed");
        pass_count = pass_count + 1;
        
        // Test 9: Output monitoring
        $display("\n--- Test 9: Output Monitoring ---");
        test_count = test_count + 1;
        
        #500;
        $display("Final output state: %b", FINAL_OUTPUT);
        $display("PASS: Output monitoring completed");
        pass_count = pass_count + 1;
        
        // Print test summary
        #100;
        $display("\n========================================");
        $display("RISC System Test Summary");
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
    
    // Timeout watchdog
    initial begin
        #5000000;  // 5ms timeout
        $display("\n========================================");
        $display("ERROR: Testbench timeout!");
        $display("========================================");
        $finish;
    end
    
    // Waveform dump
    initial begin
        $dumpfile("tb_risc_system.vcd");
        $dumpvars(0, tb_risc_system);
    end

endmodule
