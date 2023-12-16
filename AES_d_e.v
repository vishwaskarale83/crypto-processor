`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 07:10:43 PM
// Design Name: 
// Module Name: AES_d_e
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



module AES_d_e(
input AES_Encryption_flag,
input AES_Decryption_flag,
output reg [1:0] ENCRYPT
//output reg e_reset = 1,
//output reg d_reset = 1
    );
    
    always @(AES_Encryption_flag or AES_Decryption_flag) begin
	   if(AES_Encryption_flag == 1 && AES_Decryption_flag == 0) 
	       ENCRYPT = 2'b10;
       else if(AES_Encryption_flag == 0 && AES_Decryption_flag == 1) 
	       ENCRYPT = 2'b01;
	   else 
	       ENCRYPT = 2'b00;
	end
    
    
    
endmodule




