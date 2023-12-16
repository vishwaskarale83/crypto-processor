`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2020 10:58:25 PM
// Design Name: 
// Module Name: Remainder_finder
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


module Remainder_finder(A,B,divisor_valid,dividend_valid,remainder_valid,remainder,clk);

input [255:0] A;
input [127:0] B;
input divisor_valid,dividend_valid,clk;

output reg remainder_valid = 0;
output reg [127:0] remainder = 0;

reg [255:0] a;
reg [127:0] b;

always@(posedge clk) begin
    if (divisor_valid == 1 && dividend_valid == 1) begin
        a = A;
        b = B;
        remainder = a%b;
        remainder_valid = 1;
    end
    
    else begin
        remainder_valid = 0;
    end
end
endmodule

