`timescale 1ns / 1ps
//==============================================================================
// Module: Key_generator (Stub for CI/CD)
// Description: Simplified stub version of Key_generator for open-source tools
//              Full version requires Xilinx IP cores (div_gen_1) not available
//              in Icarus Verilog. This stub provides the same interface but
//              generates fixed keys for compilation testing.
// 
// Note: For FPGA synthesis, use the full key_manager.v with Xilinx IP
//==============================================================================

module Key_generator(
    input clk,
    input rst,
    input randomize,
    input AES_key_new,
    input private_key_new,
    output reg AES_key_gen,
    output reg private_key_gen,
    output reg [127:0] private_key,
    output reg [127:0] AES_key_final,
    output reg [127:0] N
);

    // Fixed test keys for compilation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            private_key <= 128'h0;
            AES_key_final <= 128'h0;
            N <= 128'h0;
            AES_key_gen <= 1'b0;
            private_key_gen <= 1'b0;
        end else begin
            // Generate simple fixed keys for testing
            if (AES_key_new) begin
                AES_key_final <= 128'h2b7e151628aed2a6abf7158809cf4f3c; // AES test key
                AES_key_gen <= 1'b1;
            end else begin
                AES_key_gen <= 1'b0;
            end
            
            if (private_key_new) begin
                private_key <= 128'hdeadbeefcafebabe0123456789abcdef; // RSA test key
                N <= 128'hfedcba9876543210cafebabadeadbeef;
                private_key_gen <= 1'b1;
            end else begin
                private_key_gen <= 1'b0;
            end
        end
    end

endmodule
