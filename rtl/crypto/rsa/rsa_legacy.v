`timescale 1ns / 1ps    
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineers: Riya, Atharva, Vishwas 
// Create Date: 13.04.2019 09:44:31
// Design Name:  
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module RSA(new,clock,OUT_Encryptor_correct,OUT_Decryptor_correct,OUT_Encryptor_wrong,OUT_Decryptor_wrong,message,decoded_message,flag);

parameter [16:0] key_size = 512;//
parameter [16:0] key_size_1 = 512;//
//parameter WIDTH = 511;
input [127:0] message;//
wire [255:0] ciphertext;
output wire [255:0] decoded_message;//
output reg flag = 0;//
//reg flag1 = 0;

/*reg [key_size_1-1:0] Test_Encryption_data = 256'h4561b9622473a3a87e81c5b26bb5712c05078474cfd9a95df661fc65acb1915b;
wire [key_size_1-1:0] Encrypted_data;
reg [key_size-1:0] Test_Decryption_data = 128'h8abcd2ef8abcd2ef8abcd2ef8abcd2ef;
wire [key_size_1-1:0]Decrypted_data;*/
//reg [key_size_1-1:0]R = 256'd19386616419536689342307928261758294406350579534344358462208866794553265963751;//2^256 mod N
wire enc_flag;//
wire dec_flag;
input clock,new;//

output reg OUT_Encryptor_correct = 0; //
output reg OUT_Decryptor_correct = 0;//
output reg OUT_Encryptor_wrong = 1; //
output reg OUT_Decryptor_wrong = 1;//

Encryptor E(message,ciphertext,clock,new,enc_flag);    

/*always@(posedge clock) begin
if(enc_flag)
    flag1 = 1;
end*/

Decryptor D(ciphertext,decoded_message,clock,new,enc_flag,dec_flag);


always@(posedge clock) begin
if (message == decoded_message) begin
    flag = 1;
    OUT_Encryptor_correct = 1;
    OUT_Encryptor_wrong = 0;
    OUT_Decryptor_correct = 1;
    OUT_Decryptor_wrong = 0;
    end
end

/*always@(posedge clock) begin
    if(Encrypted_data == Test_Encryption_data) begin
        OUT_Encryptor_correct = 1;
        OUT_Encryptor_wrong = 0;
    end
    else begin
        OUT_Encryptor_correct = 0;
        OUT_Encryptor_wrong = 1;
    end
    if(Decrypted_data == Test_Decryption_data) begin  
        

        OUT_Decryptor_correct = 1;
        OUT_Decryptor_wrong = 0;
    end
    else begin
        OUT_Decryptor_correct = 0;
        OUT_Decryptor_wrong = 1;
        
    end
end*/

endmodule

module Encryptor(IN_ENC,OUT_ENC,clk,new,enc_flag,RSA_Encryption_flag); 


parameter key_size = 18;
parameter key_size_1 = 512;
parameter WIDTH = 600;
parameter B = 33'd65537;
parameter N = 256'd53747694729607852236598641428555764681978027691941031212915614837950618889461;
parameter R = 256'd19386616419536689342307928261758294406350579534344358462208866794553265963751;
parameter input_size = 128;
parameter output_size = 256;

output reg enc_flag;
input RSA_Encryption_flag;
reg [key_size_1-1:0] OUT3 = 0;
reg [key_size_1-1:0] OUT = 1;
//reg [key_size-1:0] t1 = 0;
//reg [key_size-1:0] t2 = 0;

input clk,new;
input [input_size-1:0] IN_ENC;

output reg [output_size-1:0] OUT_ENC;

integer i = 0;
integer l = 0;
//integer loop_counter;

function [key_size_1-1:0] Montgomery;
    input [key_size_1-1:0] a;
    input [key_size_1-1:0] n;
    input [key_size_1-1:0] b;
        
    reg [key_size_1:0] result;
        
    automatic reg [key_size_1-1:0] t1;
    automatic reg [key_size_1-1:0] t2;
    automatic reg [10:0] loop_counter;    
    begin       
        t1 = 0; t2 = 0;        
        for(loop_counter = 1; loop_counter <= key_size_1; loop_counter = loop_counter + 1) begin
            t2 = t1;
            if (a[loop_counter-1] == 1)
                t2 = t2 + b;            
            if(t2[0] == 1) begin 
                t2 = t2 + n;
                t2 = t2/2;
            end           
            else
                t2 = t2/2;              
            t1 = t2;
        end    
        if (t1 >= n)
           Montgomery = t1 - n;
        else 
            Montgomery = t1;
    end
endfunction
   

function [key_size_1-1:0]restoring;
    input [WIDTH-1:0] A,B;
                                                                                                                                                            
    reg [WIDTH-1:0] Res;                                                                                
    reg [WIDTH-1:0] Rm;                                     
    reg [WIDTH-1:0] a1,b1;                                      
    reg [WIDTH:0] p1;   
    
    integer i;

    begin
        a1 = A;
        b1 = B;
        p1 = 0;
        for(i=0;i < WIDTH;i=i+1) begin 
            p1 = {p1[WIDTH-2:0],a1[WIDTH-1]};
            a1[WIDTH-1:1] = a1[WIDTH-2:0];
            p1 = p1-b1;
            if(p1[WIDTH-1] == 1) begin
                a1[0] = 0;
                p1 = p1 + b1;   
            end
            else
                a1[0] = 1;
        end
        Res = a1;  
        Rm = p1;
        restoring = Rm;
    end 
endfunction
    
   
always@(posedge clk) begin
        
        if(new) begin
            OUT = 1;
            i = 0;
            OUT_ENC = 1;
            enc_flag = 0;
        end    
        else begin
            if( RSA_Encryption_flag == 1) begin
        
               if (i < key_size-1) begin
                    
                    if(B[key_size-2-i] == 1) begin
                        OUT = Montgomery(OUT,N,IN_ENC);
                        for (l = 0; l < output_size + 1; l = l+1) begin
                            if (R[l] == 1)
                                OUT3 = OUT3 + OUT;
                            OUT = OUT*2;
                        end
                        OUT = restoring(OUT3,N);
                        OUT3 = 0;
                    end
                    
                    if(i != key_size-2) begin
                        OUT = Montgomery(OUT,N,OUT);
                        for (l = 0; l < output_size + 1; l = l+1) begin
                            if (R[l] == 1)
                                OUT3 = OUT3 + OUT;
                            OUT = OUT*2;
                        end
                        OUT = restoring(OUT3,N);
                        OUT3 = 0;
                    end
                    
                    i = i + 1;     
                    
                    if(i == key_size-1) begin
                        OUT_ENC = OUT;
                        enc_flag = 1;
                    end
                end
            end       
        end
    end
   

endmodule

/*function [255:0] inverse_calculator;
    input [255:0] e;
    input [255:0] phi;
    
    reg [255:0] d;
    
    automatic reg signed [255:0] d1 [256:0];
    automatic reg signed [255:0] r1 [256:0];
    automatic reg [256:0] a;
    automatic reg [10:0] loop_counter;   
    
    begin
        for (d1[0] = 0, r1[0] = phi, d1[1] = 1, r1[1] = e, loop_counter = 1; r1[loop_counter] > 0; loop_counter = loop_counter + 1) begin
            
            a = restoring(r1[loop_counter-1],r1[loop_counter]);
            d1[loop_counter+1] = d1[loop_counter-1] - a*d1[loop_counter];
            r1[loop_counter+1] = r1[loop_counter-1] - a*r1[loop_counter];
            
        end
        if (d1[loop_counter-1] < 0)
            d = (phi+d1[loop_counter-1]);
        else if (phi > d1[loop_counter-1] > 0)
            d = (d1[loop_counter-1]);
        
        inverse_calculator = d;     
    end      
endfunction
*/

module Decryptor(IN_DEC,OUT_DEC,clk,new,dec_flag,RSA_Decryption_flag); 

parameter key_size = 257;
parameter key_size_1 = 512;
parameter WIDTH = 600;
parameter B = 256'd6284519961441399082793771293574970242067157886577986610647186234624796616673;//60032214691049251319392412722130734923569875674997862442825790470381718953473;
parameter N = 256'd53747694729607852236598641428555764681978027691941031212915614837950618889461;
parameter R = 256'd19386616419536689342307928261758294406350579534344358462208866794553265963751;

reg [key_size_1-1:0] OUT3 = 0;
reg [key_size_1-1:0] OUT = 1;

input clk,new;
input RSA_Decryption_flag;
input [key_size-2:0] IN_DEC;

output reg [key_size-2:0] OUT_DEC;

output reg dec_flag;
integer i = 0;
integer l = 0;
//integer loop_counter;

function [key_size_1-1:0] Montgomery;
    input [key_size_1-1:0] a;
    input [key_size_1-1:0] n;
    input [key_size_1-1:0] b;
        
    reg [key_size_1:0] result;
        
    automatic reg [key_size_1-1:0] t1;
    automatic reg [key_size_1-1:0] t2;
    automatic reg [10:0] loop_counter;    
    begin       
        t1 = 0; t2 = 0;        
        for(loop_counter = 1; loop_counter <= key_size_1; loop_counter = loop_counter + 1) begin
            t2 = t1;
            if (a[loop_counter-1] == 1)
                t2 = t2 + b;            
            if(t2[0] == 1) begin 
                t2 = t2 + n;
                t2 = t2/2;
            end           
            else
                t2 = t2/2;              
            t1 = t2;
        end    
        if (t1 >= n)
           result = t1 - n;
        else 
            result = t1;
        Montgomery = result;    
    end
endfunction
   

function [key_size_1-1:0]restoring;
    input [WIDTH-1:0] A,B;
                                                                                                                                                            
    reg [WIDTH-1:0] Res;                                                                                
    reg [WIDTH-1:0] Rm;                                     
    reg [WIDTH-1:0] a1,b1;                                      
    reg [WIDTH:0] p1;   
    
    integer i;

    begin
        a1 = A;
        b1 = B;
        p1 = 0;
        for(i=0;i < WIDTH;i=i+1) begin 
            p1 = {p1[WIDTH-2:0],a1[WIDTH-1]};
            a1[WIDTH-1:1] = a1[WIDTH-2:0];
            p1 = p1-b1;
            if(p1[WIDTH-1] == 1) begin
                a1[0] = 0;
                p1 = p1 + b1;   
            end
            else
                a1[0] = 1;
        end
        Res = a1;  
        Rm = p1;
        restoring = Rm;
    end 
endfunction

   
always@(posedge clk) begin
    
        
        if(new) begin
            OUT = 1;
            i = 0;
            OUT_DEC = 1;
            dec_flag = 0;
        end        
        
        else begin
        if(RSA_Decryption_flag == 1) begin
                    
            if (i < key_size-1) begin
                
                if(B[key_size-2-i] == 1) begin
                    OUT = Montgomery(OUT,N,IN_DEC);
                    for (l = 0; l < key_size; l = l+1) begin
                        if (R[l] == 1)
                            OUT3 = OUT3 + OUT;
                        OUT = OUT*2;
                    end
                    OUT = restoring(OUT3,N);
                    OUT3 = 0;
                end
                
                if(i != key_size-2) begin
                    OUT = Montgomery(OUT,N,OUT);
                    for (l = 0; l < key_size; l = l+1) begin
                        if (R[l] == 1)
                            OUT3 = OUT3 + OUT;
                        OUT = OUT*2;
                    end
                    OUT = restoring(OUT3,N);
                    OUT3 = 0;
                end
                
                i = i + 1;     
                
                if(i == key_size-1) begin
                    OUT_DEC = OUT;
                    dec_flag = 1;
                end
            end
        end       
    end
end   

endmodule

