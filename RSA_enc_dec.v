`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2020 01:29:34 PM
// Design Name: 
// Module Name: RSA_enc_dec
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

module RSA_enc_dec(clk,new,done,IN,OUT,B,N,E_D);

input [255:0] IN;
input [127:0] N,B;
input new,clk;
input [1:0]E_D;

// p1 = 64'd11140812039935654743, p2 = 64'd9783173204143614071, N = 128'd108992493821499052737214080527692688753

output reg [1:0] done;
output reg [255:0] OUT;

reg [255:0] out;
reg [255:0] in;
reg [127:0] a,b,storage1,storage2;
reg [255:0] dividend;
reg [127:0] divisor;
reg divisor_valid,dividend_valid,product_ready,validity,loop_valid_1,loop_valid_2,exit0,assignment,dn;

integer i;

wire remainder_valid;
wire [127:0] remainder;
wire [255:0] p;

Karatsuba MUL(
    .a(a),
    .b(b),
    .p(p)  
);

Remainder_finder DIV(
    .A(dividend),
    .B(N),
    .divisor_valid(divisor_valid),
    .dividend_valid(dividend_valid),
    .clk(clk),
    .remainder_valid(remainder_valid),
    .remainder(remainder)    
);

always@(posedge clk) begin
    if (new == 1) begin
        validity = 0;
        product_ready = 0;   
        loop_valid_1 = 0;
        loop_valid_2 = 1;
        storage1 = 1;
        storage2 = 0;   
        exit0 = 1;  
        a = 0;
        b = 0;
        dn = 0;
        i = 0;
        assignment = 1;
        in = 0;
        OUT = 0;
        done = 2'b00;
        out = 0;
    end
    
    else if (~new && assignment) begin
        if (E_D == 1) begin
            in[127:0] = {64'b0,IN[63:0]};
            in[255:128] = {64'b0,IN[127:64]};
            assignment = 0;
        end
        else begin
            in = IN;
            assignment = 0;
        end
    end
    
    else if (~new && ~assignment && i != 256) begin
        if (i < 128) begin
            
            if (i == 0 && exit0) begin
                storage2 = in[127:0]%N;
                storage1 = 1;
                exit0 = 0;    
            end
            
            else if (i > 0 && i < 128 && loop_valid_1 && ~loop_valid_2) begin
                if (~product_ready) begin
                    a = storage2;
                    b = storage2;
                    validity = 1;
                    product_ready = 1;
                    divisor_valid = 0;
                    dividend_valid = 0;            
                end        
                
                else if (product_ready && validity) begin
                    dividend = p;  
                    divisor_valid = 1;
                    dividend_valid = 1;
                    validity = 0;
                end
                
                else if (remainder_valid) begin
                    product_ready = 0;
                    storage2 = remainder; 
                    loop_valid_1 = 0;
                    loop_valid_2 = 1;  
                    divisor_valid = 0;
                    dividend_valid = 0;                     
                end
                
                else begin
                    dn = ~dn;
                end
            end
            
            else if (B[i] && loop_valid_2 && ~loop_valid_1) begin
                if (~product_ready) begin
                    a = storage1;
                    b = storage2;
                    validity = 1;
                    product_ready = 1;
                    divisor_valid = 0;
                    dividend_valid = 0;            
                end        
                
                else if (product_ready && validity) begin
                    dividend = p;  
                    divisor_valid = 1;
                    dividend_valid = 1;
                    validity = 0;
                end
                
                else if (remainder_valid) begin
                    product_ready = 0;
                    storage1 = remainder; 
                    loop_valid_2 = 0;   
                    divisor_valid = 0;
                    dividend_valid = 0;        
                end
                
                else begin
                    dn = ~dn;
                end            
            end
        
            else begin
                i = i + 1;
                loop_valid_1 = 1;
                loop_valid_2 = 0;
                if (i == 128) begin
                    exit0 = 1;
                    loop_valid_1 = 0;
                    loop_valid_2 = 1;
                    out[127:0] = storage1;
                end                                
            end
        end
        
        else if (i >= 128 && i < 256) begin
            
            if (i == 128 && exit0) begin
                storage2 = in[255:128]%N;
                storage1 = 1;
                exit0 = 0;    
            end
            
            else if (i > 128 && i < 256 && loop_valid_1 && ~loop_valid_2) begin
                if (~product_ready) begin
                    a = storage2;
                    b = storage2;
                    validity = 1;
                    product_ready = 1;
                    divisor_valid = 0;
                    dividend_valid = 0;            
                end        
                
                else if (product_ready && validity) begin
                    dividend = p;  
                    divisor_valid = 1;
                    dividend_valid = 1;
                    validity = 0;
                end
                
                else if (remainder_valid) begin
                    product_ready = 0;
                    storage2 = remainder; 
                    loop_valid_1 = 0;
                    loop_valid_2 = 1;  
                    divisor_valid = 0;
                    dividend_valid = 0;                     
                end
                
                else begin
                    dn = ~dn;
                end
            end
            
            else if (B[i-128] && loop_valid_2 && ~loop_valid_1) begin
                if (~product_ready) begin
                    a = storage1;
                    b = storage2;
                    validity = 1;
                    product_ready = 1;
                    divisor_valid = 0;
                    dividend_valid = 0;            
                end        
                
                else if (product_ready && validity) begin
                    dividend = p;  
                    divisor_valid = 1;
                    dividend_valid = 1;
                    validity = 0;
                end
                
                else if (remainder_valid) begin
                    product_ready = 0;
                    storage1 = remainder; 
                    loop_valid_2 = 0;   
                    divisor_valid = 0;
                    dividend_valid = 0;        
                end
                
                else begin
                    dn = ~dn;
                end            
            end
        
            else begin
                i = i + 1;
                loop_valid_1 = 1;
                loop_valid_2 = 0;
                if (i == 256) begin
                    exit0 = 1;
                    loop_valid_1 = 0;
                    loop_valid_2 = 1;
                    out[255:128] = storage1;
                end                                
            end
        end       
    end

    else begin
        if (E_D == 2'b10) begin//enc
            OUT = out;   
            done = 2'b10;     
        end
        
        else if (E_D == 2'b01) begin//dec
            OUT[63:0] = out[63:0];
            OUT[127:64] = out[191:128];
            OUT[255:128] = 0;
            done = 2'b01;
        end
        
        else begin
            done = 2'b11;
        end
    end
end

endmodule
