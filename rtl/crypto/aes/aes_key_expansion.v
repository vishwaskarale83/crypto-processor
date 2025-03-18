`timescale 1ns / 1ps
//==============================================================================
// Module: aes_key_expansion
// Description: AES-128 key expansion for round key generation
//              Implements the key schedule algorithm to generate 11 round keys
//              from the initial 128-bit key
// 
// Author: CryptoKnight Team
// Date: March 13, 2026
// Version: 2.0
//==============================================================================

`include "rtl/common/crypto_pkg.v"

module KeyGeneration(rc, key, keyout);
    
	input [3:0] rc;
	input [127:0] key;
	output [127:0] keyout;
   
	wire [31:0] w0, w1, w2, w3, tem;
         
    assign w0 = key[127:96];
    assign w1 = key[95:64];
    assign w2 = key[63:32];
    assign w3 = key[31:0];
    
    assign keyout[127:96] = w0 ^ tem ^ rcon(rc);
    assign keyout[95:64]  = w0 ^ tem ^ rcon(rc) ^ w1;
    assign keyout[63:32]  = w0 ^ tem ^ rcon(rc) ^ w1 ^ w2;
    assign keyout[31:0]   = w0 ^ tem ^ rcon(rc) ^ w1 ^ w2 ^ w3;
    
    // S-box substitutions for key expansion
    Sbox a1(w3[23:16], tem[31:24]);
    Sbox a2(w3[15:8],  tem[23:16]);
    Sbox a3(w3[7:0],   tem[15:8]);
    Sbox a4(w3[31:24], tem[7:0]);
    
    // Round constant function
    function [31:0] rcon;
        input [3:0] rc;
        case(rc + 1)	
            4'h0: rcon = 32'h8d_00_00_00;
            4'h1: rcon = 32'h01_00_00_00;
            4'h2: rcon = 32'h02_00_00_00;
            4'h3: rcon = 32'h04_00_00_00;
            4'h4: rcon = 32'h08_00_00_00;
            4'h5: rcon = 32'h10_00_00_00;
            4'h6: rcon = 32'h20_00_00_00;
            4'h7: rcon = 32'h40_00_00_00;
            4'h8: rcon = 32'h80_00_00_00;
            4'h9: rcon = 32'h1b_00_00_00;
	        4'ha: rcon = 32'h36_00_00_00;
	        4'hb: rcon = 32'h6c_00_00_00;
            default: rcon = 32'h00_00_00_00;
        endcase
    endfunction

endmodule

