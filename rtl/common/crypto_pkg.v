`timescale 1ns / 1ps
//==============================================================================
// Module: crypto_pkg
// Description: Shared parameters and constants for the crypto processor system
//              Centralizes all configuration values to ensure consistency
// 
// Author: CryptoKnight Team
// Date: March 13, 2026
// Version: 2.0
//==============================================================================

`ifndef CRYPTO_PKG_V
`define CRYPTO_PKG_V

// AES Configuration Parameters
`define AES_KEY_WIDTH       128
`define AES_BLOCK_WIDTH     128
`define AES_ROUNDS          10
`define AES_DATA_WIDTH      128

// RSA Configuration Parameters
`define RSA_KEY_WIDTH       512
`define RSA_PUBLIC_EXP      128'd65537
`define RSA_MODULUS_N       256'd53747694729607852236598641428555764681978027691941031212915614837950618889461
`define RSA_MONTGOMERY_R    256'd19386616419536689342307928261758294406350579534344358462208866794553265963751
`define RSA_INPUT_SIZE      128
`define RSA_OUTPUT_SIZE     256
`define RSA_CALC_WIDTH      600

// Processor Configuration Parameters
`define INSTR_WIDTH         15
`define DATA_WIDTH          128
`define ADDR_WIDTH          15
`define OPCODE_WIDTH        5
`define OPERAND_ADDR_WIDTH  4
`define ADDR_MODE_WIDTH     2
`define BRANCH_OFFSET_WIDTH 4

// Memory Configuration
`define INSTR_MEM_SIZE      32768  // 2^15
`define DATA_MEM_SIZE       1024   // Configurable based on needs

// Operation Encoding - Crypto Operations
`define CRYPTO_OP_IDLE      2'b00
`define CRYPTO_OP_DECRYPT   2'b01
`define CRYPTO_OP_ENCRYPT   2'b10
`define CRYPTO_OP_RESERVED  2'b11

// Operation Encoding - Crypto Algorithms
`define CRYPTO_ALG_RSA      2'b00
`define CRYPTO_ALG_AES      2'b10

// FSM State Encodings - Control Path
`define STATE_IDLE          3'b000
`define STATE_INSTR_FETCH   3'b001
`define STATE_INSTR_DECODE  3'b010
`define STATE_INITIALIZE    3'b011
`define STATE_OPER_FETCH    3'b100
`define STATE_EXECUTE       3'b101
`define STATE_STORE         3'b110

// Key Generator Parameters
`define KEYGEN_WIDTH        256
`define KEYGEN_PRIME_P3     16'd55633
`define KEYGEN_PRIME_P4     16'd35837
`define KEYGEN_SEED         127'd11383815459899755273

// Timing Parameters (in clock cycles)
`define RSA_LATENCY         500  // Approximate cycles for RSA operation
`define AES_LATENCY         12   // Approximate cycles for AES operation

// Buffer Configuration
`define CRYPTO_BUFFER_DEPTH 9    // Number of buffered operations

`endif // CRYPTO_PKG_V

