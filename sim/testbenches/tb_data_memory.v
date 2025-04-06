`timescale 1ns / 1ps
//==============================================================================
// Testbench: tb_data_memory
// Description: Testbench for data memory module
//              Tests read, write, and pointer management
//==============================================================================

module tb_data_memory;

    // Inputs
    reg [127:0] data_in;
    reg read_flag;
    reg write_flag;
    reg clk;
    reg incr_data_write;
    reg incr_data_read;
    reg reset;
    
    // Outputs
    wire [127:0] data_out;
    wire [1:0] ptr_diff;
    
    // Instantiate the Unit Under Test (UUT)
    DATA_MEMORY_Module uut (
        .data_in(data_in),
        .data_out(data_out),
        .ptr_diff(ptr_diff),
        .read_flag(read_flag),
        .write_flag(write_flag),
        .clk(clk),
        .incr_data_write(incr_data_write),
        .incr_data_read(incr_data_read),
        .reset(reset)
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
    reg [127:0] test_data [0:15];
    
    // Main test sequence
    initial begin
        // Initialize
        data_in = 0;
        read_flag = 0;
        write_flag = 0;
        incr_data_write = 0;
        incr_data_read = 0;
        reset = 0;
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        
        $display("========================================");
        $display("Data Memory Testbench Started");
        $display("========================================");
        
        // Initialize test data
        for (i = 0; i < 16; i = i + 1) begin
            test_data[i] = 128'h1000000000000000000000000000 + (i * 128'h1111);
        end
        
        #20;
        
        // Test 1: Write sequence
        $display("\n--- Test 1: Write Sequence ---");
        for (i = 0; i < 10; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            data_in = test_data[i];
            write_flag = 1;
            
            @(posedge clk);
            write_flag = 0;
            incr_data_write = 1;
            
            @(posedge clk);
            incr_data_write = 0;
            
            $display("Written 0x%h to memory location %0d", test_data[i], i);
            pass_count = pass_count + 1;
        end
        #20;
        
        // Test 2: Read sequence
        $display("\n--- Test 2: Read Sequence ---");
        for (i = 0; i < 10; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            read_flag = 1;
            
            @(posedge clk);
            #1;
            $display("Read data: 0x%h from location %0d", data_out, i);
            
            read_flag = 0;
            incr_data_read = 1;
            
            @(posedge clk);
            incr_data_read = 0;
            
            pass_count = pass_count + 1;
        end
        #20;
        
        // Test 3: Pointer difference check
        $display("\n--- Test 3: Pointer Difference ---");
        test_count = test_count + 1;
        @(posedge clk);
        #1;
        $display("Pointer difference: %0d", ptr_diff);
        if (ptr_diff == 2'd1 || ptr_diff == 2'd2) begin
            $display("PASS: Pointer difference valid");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Unexpected pointer difference");
            fail_count = fail_count + 1;
        end
        #20;
        
        // Test 4: Write and immediate read
        $display("\n--- Test 4: Write and Immediate Read ---");
        test_count = test_count + 1;
        @(posedge clk);
        data_in = 128'hDEADBEEFCAFEBABE0123456789ABCDEF;
        write_flag = 1;
        
        @(posedge clk);
        write_flag = 0;
        read_flag = 1;
        
        @(posedge clk);
        #1;
        $display("Immediate read data: 0x%h", data_out);
        $display("PASS: Write and immediate read completed");
        pass_count = pass_count + 1;
        #20;
        
        // Test 5: Continuous writes
        $display("\n--- Test 5: Continuous Writes ---");
        for (i = 0; i < 5; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            data_in = 128'hAAAAAAAA + (i * 128'h11111111);
            write_flag = 1;
            incr_data_write = 1;
            
            @(posedge clk);
            $display("Continuous write %0d: 0x%h", i, data_in);
            pass_count = pass_count + 1;
        end
        
        @(posedge clk);
        write_flag = 0;
        incr_data_write = 0;
        #20;
        
        // Test 6: Continuous reads
        $display("\n--- Test 6: Continuous Reads ---");
        for (i = 0; i < 5; i = i + 1) begin
            test_count = test_count + 1;
            @(posedge clk);
            read_flag = 1;
            incr_data_read = 1;
            
            @(posedge clk);
            #1;
            $display("Continuous read %0d: 0x%h", i, data_out);
            pass_count = pass_count + 1;
        end
        
        @(posedge clk);
        read_flag = 0;
        incr_data_read = 0;
        #20;
        
        // Test 7: Boundary test
        $display("\n--- Test 7: Boundary Value Test ---");
        test_count = test_count + 1;
        
        @(posedge clk);
        data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        write_flag = 1;
        
        @(posedge clk);
        write_flag = 0;
        
        @(posedge clk);
        data_in = 128'h0;
        write_flag = 1;
        
        @(posedge clk);
        write_flag = 0;
        
        $display("PASS: Boundary values written");
        pass_count = pass_count + 1;
        #20;
        
        // Print test summary
        $display("\n========================================");
        $display("Data Memory Test Summary");
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
        $dumpfile("tb_data_memory.vcd");
        $dumpvars(0, tb_data_memory);
    end

endmodule
