`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2020 10:57:43 PM
// Design Name: 
// Module Name: Karatsuba
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

module Karatsuba
#(parameter WIDTH = 128)(
input [WIDTH-1:0] a,
input [WIDTH-1:0] b,
//input enable,
output [2*WIDTH-1:0] p
);

generate 

if (WIDTH == 1)begin
    assign p = a & b;    
end

else begin
    wire [WIDTH-1:0] p1,p2,p3,p4;
    Karatsuba #(.WIDTH(WIDTH/2))Karatsuba1(.a(a[WIDTH-1:WIDTH/2]),.b(b[WIDTH-1:WIDTH/2]),.p(p1));
    Karatsuba #(.WIDTH(WIDTH/2))Karatsuba2(.a(a[WIDTH/2-1:0]),.b(b[WIDTH/2-1:0]),.p(p2));
    Karatsuba #(.WIDTH(WIDTH/2))Karatsuba3(.a(a[WIDTH-1:WIDTH/2]),.b(b[WIDTH/2-1:0]),.p(p3));
    Karatsuba #(.WIDTH(WIDTH/2))Karatsuba4(.a(a[WIDTH/2-1:0]),.b(b[WIDTH-1:WIDTH/2]),.p(p4));
    assign p = (2**WIDTH)*p1 + (2**(WIDTH/2))*(p3 + p4) + p2; 
end

endgenerate
endmodule

