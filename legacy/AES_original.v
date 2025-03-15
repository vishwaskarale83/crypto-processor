`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 07:11:22 PM
// Design Name: 
// Module Name: AES
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



	
module KeyGeneration(rc, key, keyout);
    
	input [3:0] rc;
	input [127:0]key;
	output [127:0] keyout;
   
	wire [31:0] w0,w1,w2,w3,tem;
         
               
       assign w0 = key[127:96];
       assign w1 = key[95:64];
       assign w2 = key[63:32];
       assign w3 = key[31:0];
       
       
       assign keyout[127:96]= w0 ^ tem ^ rcon(rc);
       assign keyout[95:64] = w0 ^ tem ^ rcon(rc)^ w1;
       assign keyout[63:32] = w0 ^ tem ^ rcon(rc)^ w1 ^ w2;
       assign keyout[31:0]  = w0 ^ tem ^ rcon(rc)^ w1 ^ w2 ^ w3;
       
       
       Sbox a1(w3[23:16] ,tem[31:24]);
       Sbox a2(w3[15:8]  ,tem[23:16]);
       Sbox a3(w3[7:0]   ,tem[15:8]);
       Sbox a4(w3[31:24] ,tem[7:0]);
       
       
       
     function [31:0]	rcon;
      input	[3:0]	rc;
      case(rc + 1)	
         4'h0: rcon=32'h8d_00_00_00;
         4'h1: rcon=32'h01_00_00_00;
         4'h2: rcon=32'h02_00_00_00;
         4'h3: rcon=32'h04_00_00_00;
         4'h4: rcon=32'h08_00_00_00;
         4'h5: rcon=32'h10_00_00_00;
         4'h6: rcon=32'h20_00_00_00;
         4'h7: rcon=32'h40_00_00_00;
         4'h8: rcon=32'h80_00_00_00;
         4'h9: rcon=32'h1b_00_00_00;
	 4'ha: rcon=32'h36_00_00_00;
	 4'hb: rcon=32'h6c_00_00_00;
         default: rcon=32'h00_00_00_00;
       endcase

     endfunction

endmodule

module aes_alu(
	input [127:0] a,b,
	input [2:0] op,			// 00 - ADD | 01 - MIX | 10 - SFT | 11 - SUB
	input clk,
	output reg [127:0] z
	);

	integer k;

	wire [7:0] w20,w21,w22,w23,w24,w25,w26,w27,w28,w29,w2a,w2b,w2c,w2d,w2e,w2f;
	wire [7:0] w30,w31,w32,w33,w34,w35,w36,w37,w38,w39,w3a,w3b,w3c,w3d,w3e,w3f;
	wire [7:0] we0,we1,we2,we3,we4,we5,we6,we7,we8,we9,wea,web,wec,wed,wee,wef;	
	wire [7:0] wb0,wb1,wb2,wb3,wb4,wb5,wb6,wb7,wb8,wb9,wba,wbb,wbc,wbd,wbe,wbf;
	wire [7:0] wd0,wd1,wd2,wd3,wd4,wd5,wd6,wd7,wd8,wd9,wda,wdb,wdc,wdd,wde,wdf;
	wire [7:0] w90,w91,w92,w93,w94,w95,w96,w97,w98,w99,w9a,w9b,w9c,w9d,w9e,w9f;

	wire [127:0] sb;
	wire [127:0] isb;

	
	
	parameter add = 3'b000, mix = 3'b001, imix = 3'b101, sft = 3'b010, isft = 3'b110, sub = 3'b011, isub = 3'b111;

	// MIX COLUMNS INSTANTIATIONS
	
	GM2 GM20(a[127:120], w20);
	GM2 GM21(a[119:112], w21);
	GM2 GM22(a[111:104], w22);
	GM2 GM23(a[103:96] , w23);
	GM2 GM24(a[95:88]  , w24);
	GM2 GM25(a[87:80]  , w25);
	GM2 GM26(a[79:72]  , w26);
	GM2 GM27(a[71:64]  , w27);
	GM2 GM28(a[63:56]  , w28);
	GM2 GM29(a[55:48]  , w29);
	GM2 GM2a(a[47:40]  , w2a);
	GM2 GM2b(a[39:32]  , w2b);
	GM2 GM2c(a[31:24]  , w2c);
	GM2 GM2d(a[23:16]  , w2d);
	GM2 GM2e(a[15:8]   , w2e);
	GM2 GM2f(a[7:0]    , w2f);

	GM3 GM30(a[127:120], w30);
	GM3 GM31(a[119:112], w31);
	GM3 GM32(a[111:104], w32);
	GM3 GM33(a[103:96] , w33);
	GM3 GM34(a[95:88]  , w34);
	GM3 GM35(a[87:80]  , w35);
	GM3 GM36(a[79:72]  , w36);
	GM3 GM37(a[71:64]  , w37);
	GM3 GM38(a[63:56]  , w38);
	GM3 GM39(a[55:48]  , w39);
	GM3 GM3a(a[47:40]  , w3a);
	GM3 GM3b(a[39:32]  , w3b);
	GM3 GM3c(a[31:24]  , w3c);
	GM3 GM3d(a[23:16]  , w3d);
	GM3 GM3e(a[15:8]   , w3e);
	GM3 GM3f(a[7:0]    , w3f);

	GME GME0(a[127:120], we0);
	GME GME1(a[119:112], we1);
	GME GME2(a[111:104], we2);
	GME GME3(a[103:96] , we3);
	GME GME4(a[95:88]  , we4);
	GME GME5(a[87:80]  , we5);
	GME GME6(a[79:72]  , we6);
	GME GME7(a[71:64]  , we7);
	GME GME8(a[63:56]  , we8);
	GME GME9(a[55:48]  , we9);
	GME GMEa(a[47:40]  , wea);
	GME GMEb(a[39:32]  , web);
	GME GMEc(a[31:24]  , wec);
	GME GMEd(a[23:16]  , wed);
	GME GMEe(a[15:8]   , wee);
	GME GMEf(a[7:0]    , wef);

	GMB GMB0(a[127:120], wb0);
	GMB GMB1(a[119:112], wb1);
	GMB GMB2(a[111:104], wb2);
	GMB GMB3(a[103:96] , wb3);
	GMB GMB4(a[95:88]  , wb4);
	GMB GMB5(a[87:80]  , wb5);
	GMB GMB6(a[79:72]  , wb6);
	GMB GMB7(a[71:64]  , wb7);
	GMB GMB8(a[63:56]  , wb8);
	GMB GMB9(a[55:48]  , wb9);
	GMB GMBa(a[47:40]  , wba);
	GMB GMBb(a[39:32]  , wbb);
	GMB GMBc(a[31:24]  , wbc);
	GMB GMBd(a[23:16]  , wbd);
	GMB GMBe(a[15:8]   , wbe);
	GMB GMBf(a[7:0]    , wbf);

	GMD GMD0(a[127:120], wd0);
	GMD GMD1(a[119:112], wd1);
	GMD GMD2(a[111:104], wd2);
	GMD GMD3(a[103:96] , wd3);
	GMD GMD4(a[95:88]  , wd4);
	GMD GMD5(a[87:80]  , wd5);
	GMD GMD6(a[79:72]  , wd6);
	GMD GMD7(a[71:64]  , wd7);
	GMD GMD8(a[63:56]  , wd8);
	GMD GMD9(a[55:48]  , wd9);
	GMD GMDa(a[47:40]  , wda);
	GMD GMDb(a[39:32]  , wdb);
	GMD GMDc(a[31:24]  , wdc);
	GMD GMDd(a[23:16]  , wdd);
	GMD GMDe(a[15:8]   , wde);
	GMD GMDf(a[7:0]    , wdf);

	GM9 GM90(a[127:120], w90);
	GM9 GM91(a[119:112], w91);
	GM9 GM92(a[111:104], w92);
	GM9 GM93(a[103:96] , w93);
	GM9 GM94(a[95:88]  , w94);
	GM9 GM95(a[87:80]  , w95);
	GM9 GM96(a[79:72]  , w96);
	GM9 GM97(a[71:64]  , w97);
	GM9 GM98(a[63:56]  , w98);
	GM9 GM99(a[55:48]  , w99);
	GM9 GM9a(a[47:40]  , w9a);
	GM9 GM9b(a[39:32]  , w9b);
	GM9 GM9c(a[31:24]  , w9c);
	GM9 GM9d(a[23:16]  , w9d);
	GM9 GM9e(a[15:8]   , w9e);
	GM9 GM9f(a[7:0]    , w9f);

	// SUBSTITUTION INSTANTIATION

	Sbox S0(a[7:0]      , sb[7:0]);
	Sbox S1(a[15:8]     , sb[15:8]);
	Sbox S2(a[23:16]    , sb[23:16]);
	Sbox S3(a[31:24]    , sb[31:24]);
	Sbox S4(a[39:32]    , sb[39:32]);
	Sbox S5(a[47:40]    , sb[47:40]);
	Sbox S6(a[55:48]    , sb[55:48]);
	Sbox S7(a[63:56]    , sb[63:56]);
	Sbox S8(a[71:64]    , sb[71:64]);
	Sbox S9(a[79:72]    , sb[79:72]);
	Sbox S10(a[87:80]   , sb[87:80]);
	Sbox S11(a[95:88]   , sb[95:88]);
	Sbox S12(a[103:96]  , sb[103:96]);
	Sbox S13(a[111:104] , sb[111:104]);
	Sbox S14(a[119:112] , sb[119:112]);
	Sbox S15(a[127:120] , sb[127:120]);

	// INVERSE SUBSTITUTION INSTANTIATION

	iSbox iS0(a[7:0]      , isb[7:0]);
	iSbox iS1(a[15:8]     , isb[15:8]);
	iSbox iS2(a[23:16]    , isb[23:16]);
	iSbox iS3(a[31:24]    , isb[31:24]);
	iSbox iS4(a[39:32]    , isb[39:32]);
	iSbox iS5(a[47:40]    , isb[47:40]);
	iSbox iS6(a[55:48]    , isb[55:48]);
	iSbox iS7(a[63:56]    , isb[63:56]);
	iSbox iS8(a[71:64]    , isb[71:64]);
	iSbox iS9(a[79:72]    , isb[79:72]);
	iSbox iS10(a[87:80]   , isb[87:80]);
	iSbox iS11(a[95:88]   , isb[95:88]);
	iSbox iS12(a[103:96]  , isb[103:96]);
	iSbox iS13(a[111:104] , isb[111:104]);
	iSbox iS14(a[119:112] , isb[119:112]);
	iSbox iS15(a[127:120] , isb[127:120]);
	
	always @(posedge clk) begin
	case(op)
		add:begin
			z <= a ^ b;
		end
		mix:begin
			z[127:120] <= w20 ^ w31 ^ a[111:104] ^ a[103:96];
			z[119:112] <= a[127:120] ^ w21 ^ w32 ^ a[103:96];
			z[111:104] <= a[127:120] ^ a[119:112] ^ w22 ^ w33;	
			z[103:96]  <= w30 ^ a[119:112] ^ a[111:104] ^ w23;

			z[95:88]   <= w24 ^ w35 ^ a[79:72] ^ a[71:64];
			z[87:80]   <= a[95:88] ^ w25 ^ w36 ^ a[71:64];
			z[79:72]   <= a[95:88] ^ a[87:80] ^ w26 ^ w37;
			z[71:64]   <= w34 ^ a[87:80] ^ a[79:72] ^ w27;

			z[63:56]   <= w28 ^ w39 ^ a[47:40] ^ a[39:32];
			z[55:48]   <= a[63:56] ^ w29 ^ w3a ^ a[39:32];
			z[47:40]   <= a[63:56] ^ a[55:48] ^ w2a ^ w3b;
			z[39:32]   <= w38 ^ a[55:48] ^ a[47:40] ^ w2b;

			z[31:24]   <= w2c ^ w3d ^ a[15:8] ^ a[7:0];
			z[23:16]   <= a[31:24] ^ w2d ^ w3e ^ a[7:0];
			z[15:8]    <= a[31:24] ^ a[23:16] ^ w2e ^ w3f;
			z[7:0]     <= w3c ^ a[23:16] ^ a[15:8] ^ w2f;
		end
		imix:begin
			z[127:120] <= we0 ^ wb1 ^ wd2 ^ w93;
			z[119:112] <= w90 ^ we1 ^ wb2 ^ wd3;	
			z[111:104] <= wd0 ^ w91 ^ we2 ^ wb3;	
			z[103:96]  <= wb0 ^ wd1 ^ w92 ^ we3;

			z[95:88]   <= we4 ^ wb5 ^ wd6 ^ w97;
			z[87:80]   <= w94 ^ we5 ^ wb6 ^ wd7;
			z[79:72]   <= wd4 ^ w95 ^ we6 ^ wb7;
			z[71:64]   <= wb4 ^ wd5 ^ w96 ^ we7;

			z[63:56]   <= we8 ^ wb9 ^ wda ^ w9b;
			z[55:48]   <= w98 ^ we9 ^ wba ^ wdb;
			z[47:40]   <= wd8 ^ w99 ^ wea ^ wbb;
			z[39:32]   <= wb8 ^ wd9 ^ w9a ^ web;

			z[31:24]   <= wec ^ wbd ^ wde ^ w9f;
			z[23:16]   <= w9c ^ wed ^ wbe ^ wdf;
			z[15:8]    <= wdc ^ w9d ^ wee ^ wbf;
			z[7:0]     <= wbc ^ wdd ^ w9e ^ wef;
		end
		sft:begin
			z[127:120] <= a[127:120];
			z[119:112] <= a[87:80];
			z[111:104] <= a[47:40];	
			z[103:96]  <= a[7:0];
			z[95:88]   <= a[95:88];
			z[87:80]   <= a[55:48];
			z[79:72]   <= a[15:8];
			z[71:64]   <= a[103:96];
			z[63:56]   <= a[63:56];
			z[55:48]   <= a[23:16];
			z[47:40]   <= a[111:104];
			z[39:32]   <= a[71:64];
			z[31:24]   <= a[31:24];
			z[23:16]   <= a[119:112];
			z[15:8]    <= a[79:72];
			z[7:0]     <= a[39:32];
		end
		isft:begin
			z[127:120] <= a[127:120];
			z[119:112] <= a[23:16];
			z[111:104] <= a[47:40];
			z[103:96]  <= a[71:64];
			z[95:88]   <= a[95:88];
			z[87:80]   <= a[119:112];
			z[79:72]   <= a[15:8];
			z[71:64]   <= a[39:32];
			z[63:56]   <= a[63:56];
			z[55:48]   <= a[87:80];
			z[47:40]   <= a[111:104];
			z[39:32]   <= a[7:0];
			z[31:24]   <= a[31:24];
			z[23:16]   <= a[55:48];
			z[15:8]    <= a[79:72];
			z[7:0]     <= a[103:96];
		end
		sub:begin
			z <= sb;
		end		
		isub:begin
			z <= isb;
		end
	endcase
	end
	
endmodule
	
module AES (
	input clk,
//	input [127:0] keyin,
//	input [127:0] datain,
//	input reset,
//	output reg [127:0] dataout,
	output reg DONE = 0,
	output reg DONEb = 1,
	input [1:0]ENCRYPT,
	input reset,
	input enc_dec,
	input [127:0] datain,
	output reg [127:0] dataout,
	input [127:0]keyin
//	input [127:0]keyin,
	//input RSA_decflag,

	);
	
	//reg [127:0] keyin = 128'h2b7e151628aed2a6abf7158809cf4f3c;
	
//	reg [127:0] datain = 128'h3925841d02dc09fbdc118597196a0b32;
	
	
	
	wire [127:0] statekey;
	
	wire [127:0] alu_z;	
	
	reg [6:0] j = 0;
	reg [3:0] round = 0;
	reg [2:0] operation = 0;
	reg [127:0] alu_a = 0;
	reg [127:0] alu_b = 0;

	reg [127:0] ekey [0:10];

	parameter add = 3'b000, mix = 3'b001, imix = 3'b101, sft = 3'b010, isft = 3'b110, sub = 3'b011, isub = 3'b111;

	KeyGeneration K1(round, alu_b, statekey);
	aes_alu A1(alu_a, alu_b, operation, clk, alu_z);
	
	/*always @(AES_Eflag or AES_Dflag) begin
	   if(AES_Eflag == 1 && AES_Dflag == 0) begin
	       ENCRYPT = 2'b10;
	       reset = 0;
	   end    
	   else if(AES_Dflag == 1 && AES_Eflag == 0) begin
	       ENCRYPT = 2'b01;
	       reset = 0;    
	   end    
	   else
	           reset = 1;
	end*/
	
	
	always @(posedge clk) begin
//	        if(ENCRYPT == 2'b10 && enc_dec == 1) begin
//                 datain = 128'h3243f6a8885a308d313198a2e0370734;
//            end
//            else if(ENCRYPT == 2'b01 && enc_dec == 0)begin
//                datain = 128'h3925841d02dc09fbdc118597196a0b32;
//            end
            if(!DONE) begin        	
                j = j + 1;
            end
            if(reset) begin
                j = 7'b1111111;
            end
       
	end
	
	always @(negedge clk) begin
	    if(reset) begin
	        DONE = 0;
	        DONEb = 1;
		round = 0;
	    end 
	    else begin
    		if(ENCRYPT == 2'b10 && enc_dec == 1) begin

	   	       	if(j == 1) begin	
				    alu_a = datain;
				    alu_b = keyin;
				    operation = add;
			    end	
			    else if(j>=2 & j < 38) begin
				    case(j - 1 - (round * 4)) 
					   1:begin
						  alu_a = alu_z;
						  operation = sub;		
					   end
					   2:begin
						  alu_a = alu_z;
						  operation = sft;
					   end
					   3:begin
						  alu_a = alu_z;
						  operation = mix;
					   end
					   4:begin
						  round = round + 1;
						  alu_a = alu_z;
						  alu_b = statekey;
						  operation = add;
					   end
				    endcase
			     end
			     else begin
				    case(j - 37)	
					   1:begin		
						  alu_a = alu_z;
						  operation = sub;			
					   end
					   2:begin
						  alu_a = alu_z;
						  operation = sft;
					   end	
					   3:begin
						  round = round + 1;
						  alu_a = alu_z;
						  alu_b = statekey;
						  operation = add;
					   end
				    endcase
			     end
			     if(j == 41) begin
				        dataout = alu_z;
				        DONE = 1;
				        DONEb = 0;
//				        if(dataout == 128'h3925841d02dc09fbdc118597196a0b32) begin
//				            DONE = 1;
//				            DONEb = 0;
//				        end
			     end
		    end
            else if(ENCRYPT == 2'b01 && enc_dec == 0)begin
                   if(j == 1) begin
                            alu_b = keyin;
                            ekey[0] = keyin;
                        end
                   if(j > 1 & j < 12) begin
                       ekey[j - 1] = statekey;
                       alu_b = statekey;
                       round = j - 1;
                   end
                   if(j == 12) begin
                       alu_a = datain;
                       alu_b = ekey[10];
                       operation = add;
                   end
                   if(j == 13) begin
                       alu_a = alu_z;
                       operation = isft;
                   end
                   if(j == 14) begin
                        alu_a = alu_z;
                        operation = isub;
                   end
                   if(j > 14 & j < 51) begin
                      case((j - 14) % 4)
                         1:begin
                            alu_a = alu_z;
                            alu_b = ekey[((51 - j) / 4)];
                            operation = add;
                         end
                         2:begin
                            alu_a = alu_z;
                            operation =  imix;
                         end	
                         3:begin
                            alu_a = alu_z;
                            operation = isft;
                         end
                         0:begin
                            alu_a = alu_z;
                            operation = isub;
                         end
                      endcase
                   end
                   if(j == 51) begin
                     alu_a = alu_z;
                     alu_b = keyin;
                     operation = add;
                   end
                   if(j == 52) begin
                            dataout = alu_z;
                            DONE = 1;
                            DONEb = 0;
//                            if(dataout == 128'h3243f6a8885a308d313198a2e0370734) begin
//                                 DONE = 1;
//                                 DONEb = 0;
//                            end
                   end
            end
        end
	end	
endmodule

module GM2(
	input [7:0] ax,
	output reg [7:0] zx
	);
	
	always @(*) begin
		case(ax)
			0: zx = 0;
			1: zx = 2;
			2: zx = 4;
			3: zx = 6;
			4: zx = 8;
			5: zx = 10;
			6: zx = 12;
			7: zx = 14;
			8: zx = 16;
			9: zx = 18;
			10: zx = 20;
			11: zx = 22;
			12: zx = 24;
			13: zx = 26;
			14: zx = 28;
			15: zx = 30;
			16: zx = 32;
			17: zx = 34;
			18: zx = 36;
			19: zx = 38;
			20: zx = 40;
			21: zx = 42;
			22: zx = 44;
			23: zx = 46;
			24: zx = 48;
			25: zx = 50;
			26: zx = 52;
			27: zx = 54;
			28: zx = 56;
			29: zx = 58;
			30: zx = 60;
			31: zx = 62;
			32: zx = 64;
			33: zx = 66;
			34: zx = 68;
			35: zx = 70;
			36: zx = 72;
			37: zx = 74;
			38: zx = 76;
			39: zx = 78;
			40: zx = 80;
			41: zx = 82;
			42: zx = 84;
			43: zx = 86;
			44: zx = 88;
			45: zx = 90;
			46: zx = 92;
			47: zx = 94;
			48: zx = 96;
			49: zx = 98;
			50: zx = 100;
			51: zx = 102;
			52: zx = 104;
			53: zx = 106;
			54: zx = 108;
			55: zx = 110;
			56: zx = 112;
			57: zx = 114;
			58: zx = 116;
			59: zx = 118;
			60: zx = 120;
			61: zx = 122;
			62: zx = 124;
			63: zx = 126;
			64: zx = 128;
			65: zx = 130;
			66: zx = 132;
			67: zx = 134;
			68: zx = 136;
			69: zx = 138;
			70: zx = 140;
			71: zx = 142;
			72: zx = 144;
			73: zx = 146;
			74: zx = 148;
			75: zx = 150;
			76: zx = 152;
			77: zx = 154;
			78: zx = 156;
			79: zx = 158;
			80: zx = 160;
			81: zx = 162;
			82: zx = 164;
			83: zx = 166;
			84: zx = 168;
			85: zx = 170;
			86: zx = 172;
			87: zx = 174;
			88: zx = 176;
			89: zx = 178;
			90: zx = 180;
			91: zx = 182;
			92: zx = 184;
			93: zx = 186;
			94: zx = 188;
			95: zx = 190;
			96: zx = 192;
			97: zx = 194;
			98: zx = 196;
			99: zx = 198;
			100: zx = 200;
			101: zx = 202;
			102: zx = 204;
			103: zx = 206;
			104: zx = 208;
			105: zx = 210;
			106: zx = 212;
			107: zx = 214;
			108: zx = 216;
			109: zx = 218;
			110: zx = 220;
			111: zx = 222;
			112: zx = 224;
			113: zx = 226;
			114: zx = 228;
			115: zx = 230;
			116: zx = 232;
			117: zx = 234;
			118: zx = 236;
			119: zx = 238;
			120: zx = 240;
			121: zx = 242;
			122: zx = 244;
			123: zx = 246;
			124: zx = 248;
			125: zx = 250;
			126: zx = 252;
			127: zx = 254;
			128: zx = 27;
			129: zx = 25;
			130: zx = 31;
			131: zx = 29;
			132: zx = 19;
			133: zx = 17;
			134: zx = 23;
			135: zx = 21;
			136: zx = 11;
			137: zx = 9;
			138: zx = 15;
			139: zx = 13;
			140: zx = 3;
			141: zx = 1;
			142: zx = 7;
			143: zx = 5;
			144: zx = 59;
			145: zx = 57;
			146: zx = 63;
			147: zx = 61;
			148: zx = 51;
			149: zx = 49;
			150: zx = 55;
			151: zx = 53;
			152: zx = 43;
			153: zx = 41;
			154: zx = 47;
			155: zx = 45;
			156: zx = 35;
			157: zx = 33;
			158: zx = 39;
			159: zx = 37;
			160: zx = 91;
			161: zx = 89;
			162: zx = 95;
			163: zx = 93;
			164: zx = 83;
			165: zx = 81;
			166: zx = 87;
			167: zx = 85;
			168: zx = 75;
			169: zx = 73;
			170: zx = 79;
			171: zx = 77;
			172: zx = 67;
			173: zx = 65;
			174: zx = 71;
			175: zx = 69;
			176: zx = 123;
			177: zx = 121;
			178: zx = 127;
			179: zx = 125;
			180: zx = 115;
			181: zx = 113;
			182: zx = 119;
			183: zx = 117;
			184: zx = 107;
			185: zx = 105;
			186: zx = 111;
			187: zx = 109;
			188: zx = 99;
			189: zx = 97;
			190: zx = 103;
			191: zx = 101;
			192: zx = 155;
			193: zx = 153;
			194: zx = 159;
			195: zx = 157;
			196: zx = 147;
			197: zx = 145;
			198: zx = 151;
			199: zx = 149;
			200: zx = 139;
			201: zx = 137;
			202: zx = 143;
			203: zx = 141;
			204: zx = 131;
			205: zx = 129;
			206: zx = 135;
			207: zx = 133;
			208: zx = 187;
			209: zx = 185;
			210: zx = 191;
			211: zx = 189;
			212: zx = 179;
			213: zx = 177;
			214: zx = 183;
			215: zx = 181;
			216: zx = 171;
			217: zx = 169;
			218: zx = 175;
			219: zx = 173;
			220: zx = 163;
			221: zx = 161;
			222: zx = 167;
			223: zx = 165;
			224: zx = 219;
			225: zx = 217;
			226: zx = 223;
			227: zx = 221;
			228: zx = 211;
			229: zx = 209;
			230: zx = 215;
			231: zx = 213;
			232: zx = 203;
			233: zx = 201;
			234: zx = 207;
			235: zx = 205;
			236: zx = 195;
			237: zx = 193;
			238: zx = 199;
			239: zx = 197;
			240: zx = 251;
			241: zx = 249;
			242: zx = 255;
			243: zx = 253;
			244: zx = 243;
			245: zx = 241;
			246: zx = 247;
			247: zx = 245;
			248: zx = 235;
			249: zx = 233;
			250: zx = 239;
			251: zx = 237;
			252: zx = 227;
			253: zx = 225;
			254: zx = 231;
			255: zx = 229;
		endcase
	end
endmodule

module GM3(
	input [7:0] ax,
	output reg [7:0] zx
	);
		
	always @(*) begin
		case (ax)
			0: zx = 0;
			1: zx = 3;
			2: zx = 6;
			3: zx = 5;
			4: zx = 12;
			5: zx = 15;
			6: zx = 10;
			7: zx = 9;
			8: zx = 24;
			9: zx = 27;
			10: zx = 30;
			11: zx = 29;
			12: zx = 20;
			13: zx = 23;
			14: zx = 18;
			15: zx = 17;
			16: zx = 48;
			17: zx = 51;
			18: zx = 54;
			19: zx = 53;
			20: zx = 60;
			21: zx = 63;
			22: zx = 58;
			23: zx = 57;
			24: zx = 40;
			25: zx = 43;
			26: zx = 46;
			27: zx = 45;
			28: zx = 36;
			29: zx = 39;
			30: zx = 34;
			31: zx = 33;
			32: zx = 96;
			33: zx = 99;
			34: zx = 102;
			35: zx = 101;
			36: zx = 108;
			37: zx = 111;
			38: zx = 106;
			39: zx = 105;
			40: zx = 120;
			41: zx = 123;
			42: zx = 126;
			43: zx = 125;
			44: zx = 116;
			45: zx = 119;
			46: zx = 114;
			47: zx = 113;
			48: zx = 80;
			49: zx = 83;
			50: zx = 86;
			51: zx = 85;
			52: zx = 92;
			53: zx = 95;
			54: zx = 90;
			55: zx = 89;
			56: zx = 72;
			57: zx = 75;
			58: zx = 78;
			59: zx = 77;
			60: zx = 68;
			61: zx = 71;
			62: zx = 66;
			63: zx = 65;
			64: zx = 192;
			65: zx = 195;
			66: zx = 198;
			67: zx = 197;
			68: zx = 204;
			69: zx = 207;
			70: zx = 202;
			71: zx = 201;
			72: zx = 216;
			73: zx = 219;
			74: zx = 222;
			75: zx = 221;
			76: zx = 212;
			77: zx = 215;
			78: zx = 210;
			79: zx = 209;
			80: zx = 240;
			81: zx = 243;
			82: zx = 246;
			83: zx = 245;
			84: zx = 252;
			85: zx = 255;
			86: zx = 250;
			87: zx = 249;
			88: zx = 232;
			89: zx = 235;
			90: zx = 238;
			91: zx = 237;
			92: zx = 228;
			93: zx = 231;
			94: zx = 226;
			95: zx = 225;
			96: zx = 160;
			97: zx = 163;
			98: zx = 166;
			99: zx = 165;
			100: zx = 172;
			101: zx = 175;
			102: zx = 170;
			103: zx = 169;
			104: zx = 184;
			105: zx = 187;
			106: zx = 190;
			107: zx = 189;
			108: zx = 180;
			109: zx = 183;
			110: zx = 178;
			111: zx = 177;
			112: zx = 144;
			113: zx = 147;
			114: zx = 150;
			115: zx = 149;
			116: zx = 156;
			117: zx = 159;
			118: zx = 154;
			119: zx = 153;
			120: zx = 136;
			121: zx = 139;
			122: zx = 142;
			123: zx = 141;
			124: zx = 132;
			125: zx = 135;
			126: zx = 130;
			127: zx = 129;
			128: zx = 155;
			129: zx = 152;
			130: zx = 157;
			131: zx = 158;
			132: zx = 151;
			133: zx = 148;
			134: zx = 145;
			135: zx = 146;
			136: zx = 131;
			137: zx = 128;
			138: zx = 133;
			139: zx = 134;
			140: zx = 143;
			141: zx = 140;
			142: zx = 137;
			143: zx = 138;
			144: zx = 171;
			145: zx = 168;
			146: zx = 173;
			147: zx = 174;
			148: zx = 167;
			149: zx = 164;
			150: zx = 161;
			151: zx = 162;
			152: zx = 179;
			153: zx = 176;
			154: zx = 181;
			155: zx = 182;
			156: zx = 191;
			157: zx = 188;
			158: zx = 185;
			159: zx = 186;
			160: zx = 251;
			161: zx = 248;
			162: zx = 253;
			163: zx = 254;
			164: zx = 247;
			165: zx = 244;
			166: zx = 241;
			167: zx = 242;
			168: zx = 227;
			169: zx = 224;
			170: zx = 229;
			171: zx = 230;
			172: zx = 239;
			173: zx = 236;
			174: zx = 233;
			175: zx = 234;
			176: zx = 203;
			177: zx = 200;
			178: zx = 205;
			179: zx = 206;
			180: zx = 199;
			181: zx = 196;
			182: zx = 193;
			183: zx = 194;
			184: zx = 211;
			185: zx = 208;
			186: zx = 213;
			187: zx = 214;
			188: zx = 223;
			189: zx = 220;
			190: zx = 217;
			191: zx = 218;
			192: zx = 91;
			193: zx = 88;
			194: zx = 93;
			195: zx = 94;
			196: zx = 87;
			197: zx = 84;
			198: zx = 81;
			199: zx = 82;
			200: zx = 67;
			201: zx = 64;
			202: zx = 69;
			203: zx = 70;
			204: zx = 79;
			205: zx = 76;
			206: zx = 73;
			207: zx = 74;
			208: zx = 107;
			209: zx = 104;
			210: zx = 109;
			211: zx = 110;
			212: zx = 103;
			213: zx = 100;
			214: zx = 97;
			215: zx = 98;
			216: zx = 115;
			217: zx = 112;
			218: zx = 117;
			219: zx = 118;
			220: zx = 127;
			221: zx = 124;
			222: zx = 121;
			223: zx = 122;
			224: zx = 59;
			225: zx = 56;
			226: zx = 61;
			227: zx = 62;
			228: zx = 55;
			229: zx = 52;
			230: zx = 49;
			231: zx = 50;
			232: zx = 35;
			233: zx = 32;
			234: zx = 37;
			235: zx = 38;
			236: zx = 47;
			237: zx = 44;
			238: zx = 41;
			239: zx = 42;
			240: zx = 11;
			241: zx = 8;
			242: zx = 13;
			243: zx = 14;
			244: zx = 7;
			245: zx = 4;
			246: zx = 1;
			247: zx = 2;
			248: zx = 19;
			249: zx = 16;
			250: zx = 21;
			251: zx = 22;
			252: zx = 31;
			253: zx = 28;
			254: zx = 25;
			255: zx = 26;
		endcase
	end
endmodule

module GME(
	input [7:0] ax,
	output reg [7:0] zx
	);
	
	always @(*) begin
		case(ax)
			0: zx=0;
			1: zx=14;
			2: zx=28;
			3: zx=18;
			4: zx=56;
			5: zx=54;
			6: zx=36;
			7: zx=42;
			8: zx=112;
			9: zx=126;
			10: zx=108;
			11: zx=98;
			12: zx=72;
			13: zx=70;
			14: zx=84;
			15: zx=90;
			16: zx=224;
			17: zx=238;
			18: zx=252;
			19: zx=242;
			20: zx=216;
			21: zx=214;
			22: zx=196;
			23: zx=202;
			24: zx=144;
			25: zx=158;
			26: zx=140;
			27: zx=130;
			28: zx=168;
			29: zx=166;
			30: zx=180;
			31: zx=186;
			32: zx=219;
			33: zx=213;
			34: zx=199;
			35: zx=201;
			36: zx=227;
			37: zx=237;
			38: zx=255;
			39: zx=241;
			40: zx=171;
			41: zx=165;
			42: zx=183;
			43: zx=185;
			44: zx=147;
			45: zx=157;
			46: zx=143;
			47: zx=129;
			48: zx=59;
			49: zx=53;
			50: zx=39;
			51: zx=41;
			52: zx=3;
			53: zx=13;
			54: zx=31;
			55: zx=17;
			56: zx=75;
			57: zx=69;
			58: zx=87;
			59: zx=89;
			60: zx=115;
			61: zx=125;
			62: zx=111;
			63: zx=97;
			64: zx=173;
			65: zx=163;
			66: zx=177;
			67: zx=191;
			68: zx=149;
			69: zx=155;
			70: zx=137;
			71: zx=135;
			72: zx=221;
			73: zx=211;
			74: zx=193;
			75: zx=207;
			76: zx=229;
			77: zx=235;
			78: zx=249;
			79: zx=247;
			80: zx=77;
			81: zx=67;
			82: zx=81;
			83: zx=95;
			84: zx=117;
			85: zx=123;
			86: zx=105;
			87: zx=103;
			88: zx=61;
			89: zx=51;
			90: zx=33;
			91: zx=47;
			92: zx=5;
			93: zx=11;
			94: zx=25;
			95: zx=23;
			96: zx=118;
			97: zx=120;
			98: zx=106;
			99: zx=100;
			100: zx=78;
			101: zx=64;
			102: zx=82;
			103: zx=92;
			104: zx=6;
			105: zx=8;
			106: zx=26;
			107: zx=20;
			108: zx=62;
			109: zx=48;
			110: zx=34;
			111: zx=44;
			112: zx=150;
			113: zx=152;
			114: zx=138;
			115: zx=132;
			116: zx=174;
			117: zx=160;
			118: zx=178;
			119: zx=188;
			120: zx=230;
			121: zx=232;
			122: zx=250;
			123: zx=244;
			124: zx=222;
			125: zx=208;
			126: zx=194;
			127: zx=204;
			128: zx=65;
			129: zx=79;
			130: zx=93;
			131: zx=83;
			132: zx=121;
			133: zx=119;
			134: zx=101;
			135: zx=107;
			136: zx=49;
			137: zx=63;
			138: zx=45;
			139: zx=35;
			140: zx=9;
			141: zx=7;
			142: zx=21;
			143: zx=27;
			144: zx=161;
			145: zx=175;
			146: zx=189;
			147: zx=179;
			148: zx=153;
			149: zx=151;
			150: zx=133;
			151: zx=139;
			152: zx=209;
			153: zx=223;
			154: zx=205;
			155: zx=195;
			156: zx=233;
			157: zx=231;
			158: zx=245;
			159: zx=251;
			160: zx=154;
			161: zx=148;
			162: zx=134;
			163: zx=136;
			164: zx=162;
			165: zx=172;
			166: zx=190;
			167: zx=176;
			168: zx=234;
			169: zx=228;
			170: zx=246;
			171: zx=248;
			172: zx=210;
			173: zx=220;
			174: zx=206;
			175: zx=192;
			176: zx=122;
			177: zx=116;
			178: zx=102;
			179: zx=104;
			180: zx=66;
			181: zx=76;
			182: zx=94;
			183: zx=80;
			184: zx=10;
			185: zx=4;
			186: zx=22;
			187: zx=24;
			188: zx=50;
			189: zx=60;
			190: zx=46;
			191: zx=32;
			192: zx=236;
			193: zx=226;
			194: zx=240;
			195: zx=254;
			196: zx=212;
			197: zx=218;
			198: zx=200;
			199: zx=198;
			200: zx=156;
			201: zx=146;
			202: zx=128;
			203: zx=142;
			204: zx=164;
			205: zx=170;
			206: zx=184;
			207: zx=182;
			208: zx=12;
			209: zx=2;
			210: zx=16;
			211: zx=30;
			212: zx=52;
			213: zx=58;
			214: zx=40;
			215: zx=38;
			216: zx=124;
			217: zx=114;
			218: zx=96;
			219: zx=110;
			220: zx=68;
			221: zx=74;
			222: zx=88;
			223: zx=86;
			224: zx=55;
			225: zx=57;
			226: zx=43;
			227: zx=37;
			228: zx=15;
			229: zx=1;
			230: zx=19;
			231: zx=29;
			232: zx=71;
			233: zx=73;
			234: zx=91;
			235: zx=85;
			236: zx=127;
			237: zx=113;
			238: zx=99;
			239: zx=109;
			240: zx=215;
			241: zx=217;
			242: zx=203;
			243: zx=197;
			244: zx=239;
			245: zx=225;
			246: zx=243;
			247: zx=253;
			248: zx=167;
			249: zx=169;
			250: zx=187;
			251: zx=181;
			252: zx=159;
			253: zx=145;
			254: zx=131;
			255: zx=141;
		endcase
	end
endmodule

module GMB(
	input [7:0] ax,
	output reg [7:0] zx
	);
	
	always @(*) begin
		case(ax)
			0: zx=0;
			1: zx=11;
			2: zx=22;
			3: zx=29;
			4: zx=44;
			5: zx=39;
			6: zx=58;
			7: zx=49;
			8: zx=88;
			9: zx=83;
			10: zx=78;
			11: zx=69;
			12: zx=116;
			13: zx=127;
			14: zx=98;
			15: zx=105;
			16: zx=176;
			17: zx=187;
			18: zx=166;
			19: zx=173;
			20: zx=156;
			21: zx=151;
			22: zx=138;
			23: zx=129;
			24: zx=232;
			25: zx=227;
			26: zx=254;
			27: zx=245;
			28: zx=196;
			29: zx=207;
			30: zx=210;
			31: zx=217;
			32: zx=123;
			33: zx=112;
			34: zx=109;
			35: zx=102;
			36: zx=87;
			37: zx=92;
			38: zx=65;
			39: zx=74;
			40: zx=35;
			41: zx=40;
			42: zx=53;
			43: zx=62;
			44: zx=15;
			45: zx=4;
			46: zx=25;
			47: zx=18;
			48: zx=203;
			49: zx=192;
			50: zx=221;
			51: zx=214;
			52: zx=231;
			53: zx=236;
			54: zx=241;
			55: zx=250;
			56: zx=147;
			57: zx=152;
			58: zx=133;
			59: zx=142;
			60: zx=191;
			61: zx=180;
			62: zx=169;
			63: zx=162;
			64: zx=246;
			65: zx=253;
			66: zx=224;
			67: zx=235;
			68: zx=218;
			69: zx=209;
			70: zx=204;
			71: zx=199;
			72: zx=174;
			73: zx=165;
			74: zx=184;
			75: zx=179;
			76: zx=130;
			77: zx=137;
			78: zx=148;
			79: zx=159;
			80: zx=70;
			81: zx=77;
			82: zx=80;
			83: zx=91;
			84: zx=106;
			85: zx=97;
			86: zx=124;
			87: zx=119;
			88: zx=30;
			89: zx=21;
			90: zx=8;
			91: zx=3;
			92: zx=50;
			93: zx=57;
			94: zx=36;
			95: zx=47;
			96: zx=141;
			97: zx=134;
			98: zx=155;
			99: zx=144;
			100: zx=161;
			101: zx=170;
			102: zx=183;
			103: zx=188;
			104: zx=213;
			105: zx=222;
			106: zx=195;
			107: zx=200;
			108: zx=249;
			109: zx=242;
			110: zx=239;
			111: zx=228;
			112: zx=61;
			113: zx=54;
			114: zx=43;
			115: zx=32;
			116: zx=17;
			117: zx=26;
			118: zx=7;
			119: zx=12;
			120: zx=101;
			121: zx=110;
			122: zx=115;
			123: zx=120;
			124: zx=73;
			125: zx=66;
			126: zx=95;
			127: zx=84;
			128: zx=247;
			129: zx=252;
			130: zx=225;
			131: zx=234;
			132: zx=219;
			133: zx=208;
			134: zx=205;
			135: zx=198;
			136: zx=175;
			137: zx=164;
			138: zx=185;
			139: zx=178;
			140: zx=131;
			141: zx=136;
			142: zx=149;
			143: zx=158;
			144: zx=71;
			145: zx=76;
			146: zx=81;
			147: zx=90;
			148: zx=107;
			149: zx=96;
			150: zx=125;
			151: zx=118;
			152: zx=31;
			153: zx=20;
			154: zx=9;
			155: zx=2;
			156: zx=51;
			157: zx=56;
			158: zx=37;
			159: zx=46;
			160: zx=140;
			161: zx=135;
			162: zx=154;
			163: zx=145;
			164: zx=160;
			165: zx=171;
			166: zx=182;
			167: zx=189;
			168: zx=212;
			169: zx=223;
			170: zx=194;
			171: zx=201;
			172: zx=248;
			173: zx=243;
			174: zx=238;
			175: zx=229;
			176: zx=60;
			177: zx=55;
			178: zx=42;
			179: zx=33;
			180: zx=16;
			181: zx=27;
			182: zx=6;
			183: zx=13;
			184: zx=100;
			185: zx=111;
			186: zx=114;
			187: zx=121;
			188: zx=72;
			189: zx=67;
			190: zx=94;
			191: zx=85;
			192: zx=1;
			193: zx=10;
			194: zx=23;
			195: zx=28;
			196: zx=45;
			197: zx=38;
			198: zx=59;
			199: zx=48;
			200: zx=89;
			201: zx=82;
			202: zx=79;
			203: zx=68;
			204: zx=117;
			205: zx=126;
			206: zx=99;
			207: zx=104;
			208: zx=177;
			209: zx=186;
			210: zx=167;
			211: zx=172;
			212: zx=157;
			213: zx=150;
			214: zx=139;
			215: zx=128;
			216: zx=233;
			217: zx=226;
			218: zx=255;
			219: zx=244;
			220: zx=197;
			221: zx=206;
			222: zx=211;
			223: zx=216;
			224: zx=122;
			225: zx=113;
			226: zx=108;
			227: zx=103;
			228: zx=86;
			229: zx=93;
			230: zx=64;
			231: zx=75;
			232: zx=34;
			233: zx=41;
			234: zx=52;
			235: zx=63;
			236: zx=14;
			237: zx=5;
			238: zx=24;
			239: zx=19;
			240: zx=202;
			241: zx=193;
			242: zx=220;
			243: zx=215;
			244: zx=230;
			245: zx=237;
			246: zx=240;
			247: zx=251;
			248: zx=146;
			249: zx=153;
			250: zx=132;
			251: zx=143;
			252: zx=190;
			253: zx=181;
			254: zx=168;
			255: zx=163;
		endcase
	end
endmodule

module Sbox(
	input [7:0] ax,
	output reg [7:0] zx
	);
	
	always @(*) begin
		case(ax)
			8'h00: zx=8'h63;
	  		8'h01: zx=8'h7c;
	  		8'h02: zx=8'h77;
	   		8'h03: zx=8'h7b;
	   		8'h04: zx=8'hf2;
	   		8'h05: zx=8'h6b;
	   		8'h06: zx=8'h6f;
	   		8'h07: zx=8'hc5;
	   		8'h08: zx=8'h30;
	   		8'h09: zx=8'h01;
	   		8'h0a: zx=8'h67;
	   		8'h0b: zx=8'h2b;
	   		8'h0c: zx=8'hfe;
	   		8'h0d: zx=8'hd7;
	   		8'h0e: zx=8'hab;
	   		8'h0f: zx=8'h76;
	   		8'h10: zx=8'hca;
	   		8'h11: zx=8'h82;
	   		8'h12: zx=8'hc9;
	   		8'h13: zx=8'h7d;
	   		8'h14: zx=8'hfa;
	   		8'h15: zx=8'h59;
	   		8'h16: zx=8'h47;
	   		8'h17: zx=8'hf0;
	   		8'h18: zx=8'had;
	   		8'h19: zx=8'hd4;
	   		8'h1a: zx=8'ha2;
	   		8'h1b: zx=8'haf;
	   		8'h1c: zx=8'h9c;
	   		8'h1d: zx=8'ha4;
	   		8'h1e: zx=8'h72;
	   		8'h1f: zx=8'hc0;
	   		8'h20: zx=8'hb7;
	   		8'h21: zx=8'hfd;
	   		8'h22: zx=8'h93;
	   		8'h23: zx=8'h26;
	   		8'h24: zx=8'h36;
	   		8'h25: zx=8'h3f;
	   		8'h26: zx=8'hf7;
	   		8'h27: zx=8'hcc;
	   		8'h28: zx=8'h34;
	   		8'h29: zx=8'ha5;
	   		8'h2a: zx=8'he5;
	   		8'h2b: zx=8'hf1;
	   		8'h2c: zx=8'h71;
	   		8'h2d: zx=8'hd8;
	   		8'h2e: zx=8'h31;
	   		8'h2f: zx=8'h15;
	   		8'h30: zx=8'h04;
	   		8'h31: zx=8'hc7;
	   		8'h32: zx=8'h23;
	   		8'h33: zx=8'hc3;
	   		8'h34: zx=8'h18;
	   		8'h35: zx=8'h96;
	   		8'h36: zx=8'h05;
	   		8'h37: zx=8'h9a;
	   		8'h38: zx=8'h07;
	   		8'h39: zx=8'h12;
	   		8'h3a: zx=8'h80;
	   		8'h3b: zx=8'he2;
	   		8'h3c: zx=8'heb;
	   		8'h3d: zx=8'h27;
	   		8'h3e: zx=8'hb2;
	   		8'h3f: zx=8'h75;
	   		8'h40: zx=8'h09;
	   		8'h41: zx=8'h83;
	   		8'h42: zx=8'h2c;
	   		8'h43: zx=8'h1a;
	   		8'h44: zx=8'h1b;
	   		8'h45: zx=8'h6e;
	   		8'h46: zx=8'h5a;
	   		8'h47: zx=8'ha0;
	   		8'h48: zx=8'h52;
	   		8'h49: zx=8'h3b;
	   		8'h4a: zx=8'hd6;
	   		8'h4b: zx=8'hb3;
	   		8'h4c: zx=8'h29;
	   		8'h4d: zx=8'he3;
	   		8'h4e: zx=8'h2f;
	   		8'h4f: zx=8'h84;
	   		8'h50: zx=8'h53;
	   		8'h51: zx=8'hd1;
	   		8'h52: zx=8'h00;
	   		8'h53: zx=8'hed;
	   		8'h54: zx=8'h20;
	   		8'h55: zx=8'hfc;
	   		8'h56: zx=8'hb1;
	   		8'h57: zx=8'h5b;
	   		8'h58: zx=8'h6a;
	   		8'h59: zx=8'hcb;
	   		8'h5a: zx=8'hbe;
	   		8'h5b: zx=8'h39;
	   		8'h5c: zx=8'h4a;
	   		8'h5d: zx=8'h4c;
	   		8'h5e: zx=8'h58;
	   		8'h5f: zx=8'hcf;
	   		8'h60: zx=8'hd0;
	   		8'h61: zx=8'hef;
	   		8'h62: zx=8'haa;
	   		8'h63: zx=8'hfb;
	   		8'h64: zx=8'h43;
	   		8'h65: zx=8'h4d;
	   		8'h66: zx=8'h33;
	   		8'h67: zx=8'h85;
	   		8'h68: zx=8'h45;
	   		8'h69: zx=8'hf9;
	   		8'h6a: zx=8'h02;
	   		8'h6b: zx=8'h7f;
	   		8'h6c: zx=8'h50;
	   		8'h6d: zx=8'h3c;
	   		8'h6e: zx=8'h9f;
	   		8'h6f: zx=8'ha8;
	   		8'h70: zx=8'h51;
	   		8'h71: zx=8'ha3;
	   		8'h72: zx=8'h40;
	   		8'h73: zx=8'h8f;
	   		8'h74: zx=8'h92;
	   		8'h75: zx=8'h9d;
	   		8'h76: zx=8'h38;
	   		8'h77: zx=8'hf5;
	   		8'h78: zx=8'hbc;
	   		8'h79: zx=8'hb6;
	   		8'h7a: zx=8'hda;
	   		8'h7b: zx=8'h21;
	   		8'h7c: zx=8'h10;
	   		8'h7d: zx=8'hff;
	   		8'h7e: zx=8'hf3;
	   		8'h7f: zx=8'hd2;
	   		8'h80: zx=8'hcd;
	   		8'h81: zx=8'h0c;
	   		8'h82: zx=8'h13;
	   		8'h83: zx=8'hec;
	   		8'h84: zx=8'h5f;
	   		8'h85: zx=8'h97;
	   		8'h86: zx=8'h44;
	   		8'h87: zx=8'h17;
	   		8'h88: zx=8'hc4;
	   		8'h89: zx=8'ha7;
	   		8'h8a: zx=8'h7e;
	   		8'h8b: zx=8'h3d;
	  		8'h8c: zx=8'h64;
	   		8'h8d: zx=8'h5d;
	   		8'h8e: zx=8'h19;
	   		8'h8f: zx=8'h73;
	   		8'h90: zx=8'h60;
	   		8'h91: zx=8'h81;
	   		8'h92: zx=8'h4f;
	   		8'h93: zx=8'hdc;
	   		8'h94: zx=8'h22;
	   		8'h95: zx=8'h2a;
	   		8'h96: zx=8'h90;
	   		8'h97: zx=8'h88;
	   		8'h98: zx=8'h46;
	   		8'h99: zx=8'hee;
	   		8'h9a: zx=8'hb8;
	   		8'h9b: zx=8'h14;
	   		8'h9c: zx=8'hde;
	   		8'h9d: zx=8'h5e;
	   		8'h9e: zx=8'h0b;
	   		8'h9f: zx=8'hdb;
	   		8'ha0: zx=8'he0;
	   		8'ha1: zx=8'h32;
	   		8'ha2: zx=8'h3a;
	   		8'ha3: zx=8'h0a;
	   		8'ha4: zx=8'h49;
	   		8'ha5: zx=8'h06;
	   		8'ha6: zx=8'h24;
	   		8'ha7: zx=8'h5c;
	   		8'ha8: zx=8'hc2;
	   		8'ha9: zx=8'hd3;
	   		8'haa: zx=8'hac;
	   		8'hab: zx=8'h62;
	   		8'hac: zx=8'h91;
	   		8'had: zx=8'h95;
	   		8'hae: zx=8'he4;
	   		8'haf: zx=8'h79;
	   		8'hb0: zx=8'he7;
	   		8'hb1: zx=8'hc8;
	   		8'hb2: zx=8'h37;
	   		8'hb3: zx=8'h6d;
	   		8'hb4: zx=8'h8d;
	   		8'hb5: zx=8'hd5;
	   		8'hb6: zx=8'h4e;
	   		8'hb7: zx=8'ha9;
	   		8'hb8: zx=8'h6c;
	   		8'hb9: zx=8'h56;
	   		8'hba: zx=8'hf4;
	   		8'hbb: zx=8'hea;
	   		8'hbc: zx=8'h65;
	   		8'hbd: zx=8'h7a;
	   		8'hbe: zx=8'hae;
	   		8'hbf: zx=8'h08;
	   		8'hc0: zx=8'hba;
	   		8'hc1: zx=8'h78;
	   		8'hc2: zx=8'h25;
	   		8'hc3: zx=8'h2e;
	   		8'hc4: zx=8'h1c;
	   		8'hc5: zx=8'ha6;
	   		8'hc6: zx=8'hb4;
	   		8'hc7: zx=8'hc6;
	   		8'hc8: zx=8'he8;
	   		8'hc9: zx=8'hdd;
	   		8'hca: zx=8'h74;
	   		8'hcb: zx=8'h1f;
	   		8'hcc: zx=8'h4b;
	   		8'hcd: zx=8'hbd;
	   		8'hce: zx=8'h8b;
	   		8'hcf: zx=8'h8a;
	   		8'hd0: zx=8'h70;
	   		8'hd1: zx=8'h3e;
	   		8'hd2: zx=8'hb5;
	   		8'hd3: zx=8'h66;
			8'hd4: zx=8'h48;
	   		8'hd5: zx=8'h03;
		   	8'hd6: zx=8'hf6;
		   	8'hd7: zx=8'h0e;
		   	8'hd8: zx=8'h61;
		   	8'hd9: zx=8'h35;
		   	8'hda: zx=8'h57;
		   	8'hdb: zx=8'hb9;
		   	8'hdc: zx=8'h86;
		   	8'hdd: zx=8'hc1;
		   	8'hde: zx=8'h1d;
		   	8'hdf: zx=8'h9e;
		   	8'he0: zx=8'he1;
		   	8'he1: zx=8'hf8;
		   	8'he2: zx=8'h98;
		   	8'he3: zx=8'h11;
		   	8'he4: zx=8'h69;
		   	8'he5: zx=8'hd9;
		   	8'he6: zx=8'h8e;
		   	8'he7: zx=8'h94;
		   	8'he8: zx=8'h9b;
		   	8'he9: zx=8'h1e;
		   	8'hea: zx=8'h87;
		   	8'heb: zx=8'he9;
		   	8'hec: zx=8'hce;
		   	8'hed: zx=8'h55;
		   	8'hee: zx=8'h28;
		   	8'hef: zx=8'hdf;
		   	8'hf0: zx=8'h8c;
		   	8'hf1: zx=8'ha1;
		   	8'hf2: zx=8'h89;
		   	8'hf3: zx=8'h0d;
		  	8'hf4: zx=8'hbf;
		  	8'hf5: zx=8'he6;
		   	8'hf6: zx=8'h42;
		   	8'hf7: zx=8'h68;
		   	8'hf8: zx=8'h41;
		   	8'hf9: zx=8'h99;
		   	8'hfa: zx=8'h2d;
		   	8'hfb: zx=8'h0f;
		   	8'hfc: zx=8'hb0;
		   	8'hfd: zx=8'h54;
			8'hfe: zx=8'hbb;
			8'hff: zx=8'h16;
		endcase
	end
endmodule			

module GMD(
	input [7:0] ax,
	output reg [7:0] zx
	);
	
	always @(*) begin
		case(ax)
			0: zx=0;
			1: zx=13;
			2: zx=26;
			3: zx=23;
			4: zx=52;
			5: zx=57;
			6: zx=46;
			7: zx=35;
			8: zx=104;
			9: zx=101;
			10: zx=114;
			11: zx=127;
			12: zx=92;
			13: zx=81;
			14: zx=70;
			15: zx=75;
			16: zx=208;
			17: zx=221;
			18: zx=202;
			19: zx=199;
			20: zx=228;
			21: zx=233;
			22: zx=254;
			23: zx=243;
			24: zx=184;
			25: zx=181;
			26: zx=162;
			27: zx=175;
			28: zx=140;
			29: zx=129;
			30: zx=150;
			31: zx=155;
			32: zx=187;
			33: zx=182;
			34: zx=161;
			35: zx=172;
			36: zx=143;
			37: zx=130;
			38: zx=149;
			39: zx=152;
			40: zx=211;
			41: zx=222;
			42: zx=201;
			43: zx=196;
			44: zx=231;
			45: zx=234;
			46: zx=253;
			47: zx=240;
			48: zx=107;
			49: zx=102;
			50: zx=113;
			51: zx=124;
			52: zx=95;
			53: zx=82;
			54: zx=69;
			55: zx=72;
			56: zx=3;
			57: zx=14;
			58: zx=25;
			59: zx=20;
			60: zx=55;
			61: zx=58;
			62: zx=45;
			63: zx=32;
			64: zx=109;
			65: zx=96;
			66: zx=119;
			67: zx=122;
			68: zx=89;
			69: zx=84;
			70: zx=67;
			71: zx=78;
			72: zx=5;
			73: zx=8;
			74: zx=31;
			75: zx=18;
			76: zx=49;
			77: zx=60;
			78: zx=43;
			79: zx=38;
			80: zx=189;
			81: zx=176;
			82: zx=167;
			83: zx=170;
			84: zx=137;
			85: zx=132;
			86: zx=147;
			87: zx=158;
			88: zx=213;
			89: zx=216;
			90: zx=207;
			91: zx=194;
			92: zx=225;
			93: zx=236;
			94: zx=251;
			95: zx=246;
			96: zx=214;
			97: zx=219;
			98: zx=204;
			99: zx=193;
			100: zx=226;
			101: zx=239;
			102: zx=248;
			103: zx=245;
			104: zx=190;
			105: zx=179;
			106: zx=164;
			107: zx=169;
			108: zx=138;
			109: zx=135;
			110: zx=144;
			111: zx=157;
			112: zx=6;
			113: zx=11;
			114: zx=28;
			115: zx=17;
			116: zx=50;
			117: zx=63;
			118: zx=40;
			119: zx=37;
			120: zx=110;
			121: zx=99;
			122: zx=116;
			123: zx=121;
			124: zx=90;
			125: zx=87;
			126: zx=64;
			127: zx=77;
			128: zx=218;
			129: zx=215;
			130: zx=192;
			131: zx=205;
			132: zx=238;
			133: zx=227;
			134: zx=244;
			135: zx=249;
			136: zx=178;
			137: zx=191;
			138: zx=168;
			139: zx=165;
			140: zx=134;
			141: zx=139;
			142: zx=156;
			143: zx=145;
			144: zx=10;
			145: zx=7;
			146: zx=16;
			147: zx=29;
			148: zx=62;
			149: zx=51;
			150: zx=36;
			151: zx=41;
			152: zx=98;
			153: zx=111;
			154: zx=120;
			155: zx=117;
			156: zx=86;
			157: zx=91;
			158: zx=76;
			159: zx=65;
			160: zx=97;
			161: zx=108;
			162: zx=123;
			163: zx=118;
			164: zx=85;
			165: zx=88;
			166: zx=79;
			167: zx=66;
			168: zx=9;
			169: zx=4;
			170: zx=19;
			171: zx=30;
			172: zx=61;
			173: zx=48;
			174: zx=39;
			175: zx=42;
			176: zx=177;
			177: zx=188;
			178: zx=171;
			179: zx=166;
			180: zx=133;
			181: zx=136;
			182: zx=159;
			183: zx=146;
			184: zx=217;
			185: zx=212;
			186: zx=195;
			187: zx=206;
			188: zx=237;
			189: zx=224;
			190: zx=247;
			191: zx=250;
			192: zx=183;
			193: zx=186;
			194: zx=173;
			195: zx=160;
			196: zx=131;
			197: zx=142;
			198: zx=153;
			199: zx=148;
			200: zx=223;
			201: zx=210;
			202: zx=197;
			203: zx=200;
			204: zx=235;
			205: zx=230;
			206: zx=241;
			207: zx=252;
			208: zx=103;
			209: zx=106;
			210: zx=125;
			211: zx=112;
			212: zx=83;
			213: zx=94;
			214: zx=73;
			215: zx=68;
			216: zx=15;
			217: zx=2;
			218: zx=21;
			219: zx=24;
			220: zx=59;
			221: zx=54;
			222: zx=33;
			223: zx=44;
			224: zx=12;
			225: zx=1;
			226: zx=22;
			227: zx=27;
			228: zx=56;
			229: zx=53;
			230: zx=34;
			231: zx=47;
			232: zx=100;
			233: zx=105;
			234: zx=126;
			235: zx=115;
			236: zx=80;
			237: zx=93;
			238: zx=74;
			239: zx=71;
			240: zx=220;
			241: zx=209;
			242: zx=198;
			243: zx=203;
			244: zx=232;
			245: zx=229;
			246: zx=242;
			247: zx=255;
			248: zx=180;
			249: zx=185;
			250: zx=174;
			251: zx=163;
			252: zx=128;
			253: zx=141;
			254: zx=154;
			255: zx=151;
		endcase
	end
endmodule

module GM9(
	input [7:0] ax,
	output reg [7:0] zx
	);
	
	always @(*) begin
		case(ax)
			0: zx=0;
			1: zx=9;
			2: zx=18;
			3: zx=27;
			4: zx=36;
			5: zx=45;
			6: zx=54;
			7: zx=63;
			8: zx=72;
			9: zx=65;
			10: zx=90;
			11: zx=83;
			12: zx=108;
			13: zx=101;
			14: zx=126;
			15: zx=119;
			16: zx=144;
			17: zx=153;
			18: zx=130;
			19: zx=139;
			20: zx=180;
			21: zx=189;
			22: zx=166;
			23: zx=175;
			24: zx=216;
			25: zx=209;
			26: zx=202;
			27: zx=195;
			28: zx=252;
			29: zx=245;
			30: zx=238;
			31: zx=231;
			32: zx=59;
			33: zx=50;
			34: zx=41;
			35: zx=32;
			36: zx=31;
			37: zx=22;
			38: zx=13;
			39: zx=4;
			40: zx=115;
			41: zx=122;
			42: zx=97;
			43: zx=104;
			44: zx=87;
			45: zx=94;
			46: zx=69;
			47: zx=76;
			48: zx=171;
			49: zx=162;
			50: zx=185;
			51: zx=176;
			52: zx=143;
			53: zx=134;
			54: zx=157;
			55: zx=148;
			56: zx=227;
			57: zx=234;
			58: zx=241;
			59: zx=248;
			60: zx=199;
			61: zx=206;
			62: zx=213;
			63: zx=220;
			64: zx=118;
			65: zx=127;
			66: zx=100;
			67: zx=109;
			68: zx=82;
			69: zx=91;
			70: zx=64;
			71: zx=73;
			72: zx=62;
			73: zx=55;
			74: zx=44;
			75: zx=37;
			76: zx=26;
			77: zx=19;
			78: zx=8;
			79: zx=1;
			80: zx=230;
			81: zx=239;
			82: zx=244;
			83: zx=253;
			84: zx=194;
			85: zx=203;
			86: zx=208;
			87: zx=217;
			88: zx=174;
			89: zx=167;
			90: zx=188;
			91: zx=181;
			92: zx=138;
			93: zx=131;
			94: zx=152;
			95: zx=145;
			96: zx=77;
			97: zx=68;
			98: zx=95;
			99: zx=86;
			100: zx=105;
			101: zx=96;
			102: zx=123;
			103: zx=114;
			104: zx=5;
			105: zx=12;
			106: zx=23;
			107: zx=30;
			108: zx=33;
			109: zx=40;
			110: zx=51;
			111: zx=58;
			112: zx=221;
			113: zx=212;
			114: zx=207;
			115: zx=198;
			116: zx=249;
			117: zx=240;
			118: zx=235;
			119: zx=226;
			120: zx=149;
			121: zx=156;
			122: zx=135;
			123: zx=142;
			124: zx=177;
			125: zx=184;
			126: zx=163;
			127: zx=170;
			128: zx=236;
			129: zx=229;
			130: zx=254;
			131: zx=247;
			132: zx=200;
			133: zx=193;
			134: zx=218;
			135: zx=211;
			136: zx=164;
			137: zx=173;
			138: zx=182;
			139: zx=191;
			140: zx=128;
			141: zx=137;
			142: zx=146;
			143: zx=155;
			144: zx=124;
			145: zx=117;
			146: zx=110;
			147: zx=103;
			148: zx=88;
			149: zx=81;
			150: zx=74;
			151: zx=67;
			152: zx=52;
			153: zx=61;
			154: zx=38;
			155: zx=47;
			156: zx=16;
			157: zx=25;
			158: zx=2;
			159: zx=11;
			160: zx=215;
			161: zx=222;
			162: zx=197;
			163: zx=204;
			164: zx=243;
			165: zx=250;
			166: zx=225;
			167: zx=232;
			168: zx=159;
			169: zx=150;
			170: zx=141;
			171: zx=132;
			172: zx=187;
			173: zx=178;
			174: zx=169;
			175: zx=160;
			176: zx=71;
			177: zx=78;
			178: zx=85;
			179: zx=92;
			180: zx=99;
			181: zx=106;
			182: zx=113;
			183: zx=120;
			184: zx=15;
			185: zx=6;
			186: zx=29;
			187: zx=20;
			188: zx=43;
			189: zx=34;
			190: zx=57;
			191: zx=48;
			192: zx=154;
			193: zx=147;
			194: zx=136;
			195: zx=129;
			196: zx=190;
			197: zx=183;
			198: zx=172;
			199: zx=165;
			200: zx=210;
			201: zx=219;
			202: zx=192;
			203: zx=201;
			204: zx=246;
			205: zx=255;
			206: zx=228;
			207: zx=237;
			208: zx=10;
			209: zx=3;
			210: zx=24;
			211: zx=17;
			212: zx=46;
			213: zx=39;
			214: zx=60;
			215: zx=53;
			216: zx=66;
			217: zx=75;
			218: zx=80;
			219: zx=89;
			220: zx=102;
			221: zx=111;
			222: zx=116;
			223: zx=125;
			224: zx=161;
			225: zx=168;
			226: zx=179;
			227: zx=186;
			228: zx=133;
			229: zx=140;
			230: zx=151;
			231: zx=158;
			232: zx=233;
			233: zx=224;
			234: zx=251;
			235: zx=242;
			236: zx=205;
			237: zx=196;
			238: zx=223;
			239: zx=214;
			240: zx=49;
			241: zx=56;
			242: zx=35;
			243: zx=42;
			244: zx=21;
			245: zx=28;
			246: zx=7;
			247: zx=14;
			248: zx=121;
			249: zx=112;
			250: zx=107;
			251: zx=98;
			252: zx=93;
			253: zx=84;
			254: zx=79;
			255: zx=70;
		endcase
	end
endmodule

module iSbox(
	input [7:0] ax,
	output reg [7:0] zx
	);
	
	always @(*) begin
		case(ax)
			8'h0: zx=8'h52;
			8'h1: zx=8'h9;
			8'h2: zx=8'h6a;
			8'h3: zx=8'hd5;
			8'h4: zx=8'h30;
			8'h5: zx=8'h36;
			8'h6: zx=8'ha5;
			8'h7: zx=8'h38;
			8'h8: zx=8'hbf;
			8'h9: zx=8'h40;
			8'ha: zx=8'ha3;
			8'hb: zx=8'h9e;
			8'hc: zx=8'h81;
			8'hd: zx=8'hf3;
			8'he: zx=8'hd7;
			8'hf: zx=8'hfb;
			8'h10: zx=8'h7c;
			8'h11: zx=8'he3;
			8'h12: zx=8'h39;
			8'h13: zx=8'h82;
			8'h14: zx=8'h9b;
			8'h15: zx=8'h2f;
			8'h16: zx=8'hff;
			8'h17: zx=8'h87;
			8'h18: zx=8'h34;
			8'h19: zx=8'h8e;
			8'h1a: zx=8'h43;
			8'h1b: zx=8'h44;
			8'h1c: zx=8'hc4;
			8'h1d: zx=8'hde;
			8'h1e: zx=8'he9;
			8'h1f: zx=8'hcb;
			8'h20: zx=8'h54;
			8'h21: zx=8'h7b;
			8'h22: zx=8'h94;
			8'h23: zx=8'h32;
			8'h24: zx=8'ha6;
			8'h25: zx=8'hc2;
			8'h26: zx=8'h23;
			8'h27: zx=8'h3d;
			8'h28: zx=8'hee;
			8'h29: zx=8'h4c;
			8'h2a: zx=8'h95;
			8'h2b: zx=8'hb;
			8'h2c: zx=8'h42;
			8'h2d: zx=8'hfa;
			8'h2e: zx=8'hc3;
			8'h2f: zx=8'h4e;
			8'h30: zx=8'h8;
			8'h31: zx=8'h2e;
			8'h32: zx=8'ha1;
			8'h33: zx=8'h66;
			8'h34: zx=8'h28;
			8'h35: zx=8'hd9;
			8'h36: zx=8'h24;
			8'h37: zx=8'hb2;
			8'h38: zx=8'h76;
			8'h39: zx=8'h5b;
			8'h3a: zx=8'ha2;
			8'h3b: zx=8'h49;
			8'h3c: zx=8'h6d;
			8'h3d: zx=8'h8b;
			8'h3e: zx=8'hd1;
			8'h3f: zx=8'h25;
			8'h40: zx=8'h72;
			8'h41: zx=8'hf8;
			8'h42: zx=8'hf6;
			8'h43: zx=8'h64;
			8'h44: zx=8'h86;
			8'h45: zx=8'h68;
			8'h46: zx=8'h98;
			8'h47: zx=8'h16;
			8'h48: zx=8'hd4;
			8'h49: zx=8'ha4;
			8'h4a: zx=8'h5c;
			8'h4b: zx=8'hcc;
			8'h4c: zx=8'h5d;
			8'h4d: zx=8'h65;
			8'h4e: zx=8'hb6;
			8'h4f: zx=8'h92;
			8'h50: zx=8'h6c;
			8'h51: zx=8'h70;
			8'h52: zx=8'h48;
			8'h53: zx=8'h50;
			8'h54: zx=8'hfd;
			8'h55: zx=8'hed;
			8'h56: zx=8'hb9;
			8'h57: zx=8'hda;
			8'h58: zx=8'h5e;
			8'h59: zx=8'h15;
			8'h5a: zx=8'h46;
			8'h5b: zx=8'h57;
			8'h5c: zx=8'ha7;
			8'h5d: zx=8'h8d;
			8'h5e: zx=8'h9d;
			8'h5f: zx=8'h84;
			8'h60: zx=8'h90;
			8'h61: zx=8'hd8;
			8'h62: zx=8'hab;
			8'h63: zx=8'h0;
			8'h64: zx=8'h8c;
			8'h65: zx=8'hbc;
			8'h66: zx=8'hd3;
			8'h67: zx=8'ha;
			8'h68: zx=8'hf7;
			8'h69: zx=8'he4;
			8'h6a: zx=8'h58;
			8'h6b: zx=8'h5;
			8'h6c: zx=8'hb8;
			8'h6d: zx=8'hb3;
			8'h6e: zx=8'h45;
			8'h6f: zx=8'h6;
			8'h70: zx=8'hd0;
			8'h71: zx=8'h2c;
			8'h72: zx=8'h1e;
			8'h73: zx=8'h8f;
			8'h74: zx=8'hca;
			8'h75: zx=8'h3f;
			8'h76: zx=8'hf;
			8'h77: zx=8'h2;
			8'h78: zx=8'hc1;
			8'h79: zx=8'haf;
			8'h7a: zx=8'hbd;
			8'h7b: zx=8'h3;
			8'h7c: zx=8'h1;
			8'h7d: zx=8'h13;
			8'h7e: zx=8'h8a;
			8'h7f: zx=8'h6b;
			8'h80: zx=8'h3a;
			8'h81: zx=8'h91;
			8'h82: zx=8'h11;
			8'h83: zx=8'h41;
			8'h84: zx=8'h4f;
			8'h85: zx=8'h67;
			8'h86: zx=8'hdc;
			8'h87: zx=8'hea;
			8'h88: zx=8'h97;
			8'h89: zx=8'hf2;
			8'h8a: zx=8'hcf;
			8'h8b: zx=8'hce;
			8'h8c: zx=8'hf0;
			8'h8d: zx=8'hb4;
			8'h8e: zx=8'he6;
			8'h8f: zx=8'h73;
			8'h90: zx=8'h96;
			8'h91: zx=8'hac;
			8'h92: zx=8'h74;
			8'h93: zx=8'h22;
			8'h94: zx=8'he7;
			8'h95: zx=8'had;
			8'h96: zx=8'h35;
			8'h97: zx=8'h85;
			8'h98: zx=8'he2;
			8'h99: zx=8'hf9;
			8'h9a: zx=8'h37;
			8'h9b: zx=8'he8;
			8'h9c: zx=8'h1c;
			8'h9d: zx=8'h75;
			8'h9e: zx=8'hdf;
			8'h9f: zx=8'h6e;
			8'ha0: zx=8'h47;
			8'ha1: zx=8'hf1;
			8'ha2: zx=8'h1a;
			8'ha3: zx=8'h71;
			8'ha4: zx=8'h1d;
			8'ha5: zx=8'h29;
			8'ha6: zx=8'hc5;
			8'ha7: zx=8'h89;
			8'ha8: zx=8'h6f;
			8'ha9: zx=8'hb7;
			8'haa: zx=8'h62;
			8'hab: zx=8'he;
			8'hac: zx=8'haa;
			8'had: zx=8'h18;
			8'hae: zx=8'hbe;
			8'haf: zx=8'h1b;
			8'hb0: zx=8'hfc;
			8'hb1: zx=8'h56;
			8'hb2: zx=8'h3e;
			8'hb3: zx=8'h4b;
			8'hb4: zx=8'hc6;
			8'hb5: zx=8'hd2;
			8'hb6: zx=8'h79;
			8'hb7: zx=8'h20;
			8'hb8: zx=8'h9a;
			8'hb9: zx=8'hdb;
			8'hba: zx=8'hc0;
			8'hbb: zx=8'hfe;
			8'hbc: zx=8'h78;
			8'hbd: zx=8'hcd;
			8'hbe: zx=8'h5a;
			8'hbf: zx=8'hf4;
			8'hc0: zx=8'h1f;
			8'hc1: zx=8'hdd;
			8'hc2: zx=8'ha8;
			8'hc3: zx=8'h33;
			8'hc4: zx=8'h88;
			8'hc5: zx=8'h7;
			8'hc6: zx=8'hc7;
			8'hc7: zx=8'h31;
			8'hc8: zx=8'hb1;
			8'hc9: zx=8'h12;
			8'hca: zx=8'h10;
			8'hcb: zx=8'h59;
			8'hcc: zx=8'h27;
			8'hcd: zx=8'h80;
			8'hce: zx=8'hec;
			8'hcf: zx=8'h5f;
			8'hd0: zx=8'h60;
			8'hd1: zx=8'h51;
			8'hd2: zx=8'h7f;
			8'hd3: zx=8'ha9;
			8'hd4: zx=8'h19;
			8'hd5: zx=8'hb5;
			8'hd6: zx=8'h4a;
			8'hd7: zx=8'hd;
			8'hd8: zx=8'h2d;
			8'hd9: zx=8'he5;
			8'hda: zx=8'h7a;
			8'hdb: zx=8'h9f;
			8'hdc: zx=8'h93;
			8'hdd: zx=8'hc9;
			8'hde: zx=8'h9c;
			8'hdf: zx=8'hef;
			8'he0: zx=8'ha0;
			8'he1: zx=8'he0;
			8'he2: zx=8'h3b;
			8'he3: zx=8'h4d;
			8'he4: zx=8'hae;
			8'he5: zx=8'h2a;
			8'he6: zx=8'hf5;
			8'he7: zx=8'hb0;
			8'he8: zx=8'hc8;
			8'he9: zx=8'heb;
			8'hea: zx=8'hbb;
			8'heb: zx=8'h3c;
			8'hec: zx=8'h83;
			8'hed: zx=8'h53;
			8'hee: zx=8'h99;
			8'hef: zx=8'h61;
			8'hf0: zx=8'h17;
			8'hf1: zx=8'h2b;
			8'hf2: zx=8'h4;
			8'hf3: zx=8'h7e;
			8'hf4: zx=8'hba;
			8'hf5: zx=8'h77;
			8'hf6: zx=8'hd6;
			8'hf7: zx=8'h26;
			8'hf8: zx=8'he1;
			8'hf9: zx=8'h69;
			8'hfa: zx=8'h14;
			8'hfb: zx=8'h63;
			8'hfc: zx=8'h55;
			8'hfd: zx=8'h21;
			8'hfe: zx=8'hc;
			8'hff: zx=8'h7d;
		endcase
	end
endmodule




