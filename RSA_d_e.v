`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2020 01:37:18 PM
// Design Name: 
// Module Name: RSA_d_e
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

module RSA_d_e(RSA_Encryption_flag,RSA_Decryption_flag,E_D);

input RSA_Encryption_flag,RSA_Decryption_flag;
output reg [1:0]E_D = 2'b0;

 always @(RSA_Encryption_flag or RSA_Decryption_flag) begin
	   if(RSA_Encryption_flag == 1 && RSA_Decryption_flag == 0) 
	       E_D = 2'b10;
	   else if(RSA_Encryption_flag == 0 && RSA_Decryption_flag == 1) 
	       E_D = 2'b01;    
	   else 
	       E_D = 2'b00;    
 end
	
	


endmodule
