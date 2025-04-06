`timescale 1ns / 1ps
//==============================================================================
// Testbench: tb_register_bank
// Description: Testbench for register bank module
//              Tests read and write operations
//==============================================================================

module tb_register_bank;

    // Inputs
    reg [2:0] address_1;
    reg [2:0] address;
    reg [15:0] data;
    reg read_write_reg_bank;  // 0: read, 1: write
    reg clk;
    
    // Outputs
    wire [15:0] reg_data_1;
    
    // Instantiate the Unit Under Test (UUT)
    REGISTER_BANK_MODULE uut (
        .address_1(address_1),
        .address(address),
        .data(data),
        .read_write_reg_bank(read_write_reg_bank),
        .clk(clk),
        .reg_data_1(reg_data_1)
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
        // Initialize
        address_1 = 0;
        address = 0;
        data = 0;
        read_write_reg_bank = 0;
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        
        $display("========================================");
        $display("Register Bank Testbench Started");
        $display("========================================");
        
        #20;
        
        // Test 1: Write to all registers
        $display("\n--- Test 1: Write to All Registers ---");
        for (i = 0; i < 8; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            address = i;
            data = 16'h1000 + i;
            read_write_reg_bank = 1;  // Write
            
            @(posedge clk);
            $display("Written 0x%h to register R%0d", data, i);
            pass_count = pass_count + 1;
        end
        #20;
        
        // Test 2: Read from all registers
        $display("\n--- Test 2: Read from All Registers ---");
        for (i = 0; i < 8; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            address_1 = i;
            read_write_reg_bank = 0;  // Read
            
            @(posedge clk);
            #1;
            if (reg_data_1 == (16'h1000 + i)) begin
                $display("PASS: Read 0x%h from register R%0d", reg_data_1, i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Expected 0x%h, got 0x%h from R%0d", 
                         16'h1000 + i, reg_data_1, i);
                fail_count = fail_count + 1;
            end
        end
        #20;
        
        // Test 3: Overwrite registers
        $display("\n--- Test 3: Overwrite Registers ---");
        for (i = 0; i < 8; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            address = i;
            data = 16'hA000 + (i * 16'h100);
            read_write_reg_bank = 1;  // Write
            
            @(posedge clk);
            pass_count = pass_count + 1;
        end
        #20;
        
        // Verify overwrites
        $display("\n--- Verify Overwritten Values ---");
        for (i = 0; i < 8; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            address_1 = i;
            read_write_reg_bank = 0;  // Read
            
            @(posedge clk);
            #1;
            if (reg_data_1 == (16'hA000 + (i * 16'h100))) begin
                $display("PASS: Verified R%0d = 0x%h", i, reg_data_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: R%0d verification failed", i);
                fail_count = fail_count + 1;
            end
        end
        #20;
        
        // Test 4: Alternating read/write
        $display("\n--- Test 4: Alternating Read/Write ---");
        test_count = test_count + 1;
        @(posedge clk);
        address = 3'd5;
        data = 16'hBEEF;
        read_write_reg_bank = 1;
        
        @(posedge clk);
        address_1 = 3'd5;
        read_write_reg_bank = 0;
        
        @(posedge clk);
        #1;
        if (reg_data_1 == 16'hBEEF) begin
            $display("PASS: Alternating read/write successful");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Alternating read/write failed");
            fail_count = fail_count + 1;
        end
        
        // Test 5: Boundary values
        $display("\n--- Test 5: Boundary Values ---");
        test_count = test_count + 1;
        
        // Write max value
        @(posedge clk);
        address = 3'd7;
        data = 16'hFFFF;
        read_write_reg_bank = 1;
        
        @(posedge clk);
        address_1 = 3'd7;
        read_write_reg_bank = 0;
        
        @(posedge clk);
        #1;
        if (reg_data_1 == 16'hFFFF) begin
            $display("PASS: Max value stored correctly");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Max value test failed");
            fail_count = fail_count + 1;
        end
        
        // Write zero
        test_count = test_count + 1;
        @(posedge clk);
        address = 3'd0;
        data = 16'h0000;
        read_write_reg_bank = 1;
        
        @(posedge clk);
        address_1 = 3'd0;
        read_write_reg_bank = 0;
        
        @(posedge clk);
        #1;
        if (reg_data_1 == 16'h0000) begin
            $display("PASS: Zero value stored correctly");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Zero value test failed");
            fail_count = fail_count + 1;
        end
        
        // Print test summary
        #20;
        $display("\n========================================");
        $display("Register Bank Test Summary");
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
        $dumpfile("tb_register_bank.vcd");
        $dumpvars(0, tb_register_bank);
    end

endmodule
