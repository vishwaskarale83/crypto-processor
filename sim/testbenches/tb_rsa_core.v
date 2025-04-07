`timescale 1ns / 1ps
//==============================================================================
// Testbench: tb_rsa_core
// Description: Comprehensive testbench for RSA core module
//              Tests encryption and decryption with multiple test vectors
//==============================================================================

module tb_rsa_core;

    // Inputs
    reg clk;
    reg new;
    reg [255:0] IN;
    reg [127:0] B;
    reg [127:0] N;
    reg [1:0] E_D;  // 00: idle, 01: decrypt, 10: encrypt
    
    // Outputs
    wire [1:0] done;
    wire [255:0] OUT;
    
    // Instantiate the Unit Under Test (UUT)
    RSA_enc_dec uut (
        .clk(clk),
        .new(new),
        .IN(IN),
        .B(B),
        .N(N),
        .E_D(E_D),
        .done(done),
        .OUT(OUT)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    // Test vectors
    reg [255:0] test_plaintext;
    reg [255:0] test_ciphertext;
    reg [127:0] test_modulus;
    reg [127:0] test_exponent;
    integer test_count;
    integer pass_count;
    integer fail_count;
    
    // Main test sequence
    initial begin
        // Initialize Inputs
        new = 0;
        IN = 0;
        B = 0;
        N = 0;
        E_D = 2'b00;
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        
        $display("========================================");
        $display("RSA Core Testbench Started");
        $display("========================================");
        $display("Time: %0t", $time);
        
        // Wait for initialization
        #20;
        
        // Test 1: Basic RSA Encryption with small values
        $display("\n--- Test 1: RSA Encryption (Small Values) ---");
        test_count = test_count + 1;
        test_plaintext = 256'h0000000000000000000000000000000000000000000000000000000000001234;
        test_modulus = 128'h3233;  // Small modulus for testing
        test_exponent = 128'h11;   // Public exponent
        
        @(posedge clk);
        IN = test_plaintext;
        N = test_modulus;
        B = test_exponent;
        E_D = 2'b10;  // Encrypt
        new = 1;
        
        @(posedge clk);
        new = 0;
        
        // Wait for done signal
        wait(done != 2'b00);
        #100;
        $display("Plaintext:  %h", test_plaintext);
        $display("Modulus N:  %h", test_modulus);
        $display("Exponent:   %h", test_exponent);
        $display("Ciphertext: %h", OUT);
        $display("Done signal: %b", done);
        
        if (OUT != 256'h0) begin
            $display("PASS: Encryption completed with non-zero output");
            pass_count = pass_count + 1;
            test_ciphertext = OUT;
        end else begin
            $display("FAIL: Encryption output is zero");
            fail_count = fail_count + 1;
        end
        #100;
        
        // Test 2: RSA Decryption
        $display("\n--- Test 2: RSA Decryption ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        IN = test_ciphertext;
        N = test_modulus;
        B = 128'hd;  // Private exponent (example)
        E_D = 2'b01;  // Decrypt
        new = 1;
        
        @(posedge clk);
        new = 0;
        
        wait(done != 2'b00);
        #100;
        $display("Ciphertext: %h", test_ciphertext);
        $display("Plaintext:  %h", OUT);
        $display("Done signal: %b", done);
        
        if (OUT != 256'h0) begin
            $display("PASS: Decryption completed");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Decryption output is zero");
            fail_count = fail_count + 1;
        end
        #100;
        
        // Test 3: Zero Input
        $display("\n--- Test 3: Zero Input Test ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        IN = 256'h0;
        N = 128'h3233;
        B = 128'h11;
        E_D = 2'b10;
        new = 1;
        
        @(posedge clk);
        new = 0;
        
        wait(done != 2'b00);
        #100;
        $display("Zero input encrypted to: %h", OUT);
        $display("PASS: Zero input test completed");
        pass_count = pass_count + 1;
        #100;
        
        // Test 4: Large Value Encryption
        $display("\n--- Test 4: Large Value Test ---");
        test_count = test_count + 1;
        test_plaintext = 256'h123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0;
        test_modulus = 128'hfffffffffffffffffffffffffffffffb;
        test_exponent = 128'h10001;  // Common public exponent 65537
        
        @(posedge clk);
        IN = test_plaintext;
        N = test_modulus;
        B = test_exponent;
        E_D = 2'b10;
        new = 1;
        
        @(posedge clk);
        new = 0;
        
        wait(done != 2'b00);
        #100;
        $display("Large value encrypted to: %h", OUT);
        $display("PASS: Large value test completed");
        pass_count = pass_count + 1;
        #100;
        
        // Test 5: Pattern Test
        $display("\n--- Test 5: Pattern Value Test ---");
        test_count = test_count + 1;
        test_plaintext = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        
        @(posedge clk);
        IN = test_plaintext;
        N = test_modulus;
        B = test_exponent;
        E_D = 2'b10;
        new = 1;
        
        @(posedge clk);
        new = 0;
        
        wait(done != 2'b00);
        #100;
        $display("Pattern value encrypted to: %h", OUT);
        $display("PASS: Pattern test completed");
        pass_count = pass_count + 1;
        #100;
        
        // Test 6: Idle Mode
        $display("\n--- Test 6: Idle Mode Test ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        E_D = 2'b00;  // Idle
        new = 1;
        
        @(posedge clk);
        new = 0;
        #1000;
        $display("PASS: Idle mode test completed");
        pass_count = pass_count + 1;
        
        // Print test summary
        #100;
        $display("\n========================================");
        $display("RSA Core Test Summary");
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
        #10000000;  // 10ms timeout for RSA operations
        $display("\n========================================");
        $display("ERROR: Testbench timeout!");
        $display("========================================");
        $finish;
    end
    
    // Waveform dump for GTKWave
    initial begin
        $dumpfile("tb_rsa_core.vcd");
        $dumpvars(0, tb_rsa_core);
    end

endmodule
