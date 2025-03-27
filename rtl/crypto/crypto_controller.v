`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 07:05:17 PM
// Design Name: 
// Module Name: CryptoKnight
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


module CryptoKnight(Master_clk,Master_reset,operand_1,AES_Encryption_flag,AES_Decryption_flag,
RSA_Encryption_flag,RSA_Decryption_flag,enc_flag,dec_flag,AES_Encryption_correct, AES_Decryption_correct,new_data,
randomize,AES_key_new,private_key_new,FINAL_OUTPUT);

input Master_clk,Master_reset;
input [127:0]operand_1;
input AES_Encryption_flag,AES_Decryption_flag,RSA_Encryption_flag,RSA_Decryption_flag;
input new_data;
input randomize,AES_key_new,private_key_new;
output enc_flag,dec_flag;
output AES_Encryption_correct, AES_Decryption_correct;

output reg FINAL_OUTPUT;

parameter [16:0] key_size_1 = 512;
parameter dec_key_size = 256;
//reg [127:0] aes_keyin = 128'h2b7e151628aed2a6abf7158809cf4f3c;

wire [127:0]OUT_ae;
wire [127:0]OUT_ad;
wire [255:0]result;
wire  AES_Decryption_wrong, AES_Encryption_wrong;
wire [1:0] ENCRYPT;
reg rsa_ereset=1,rsa_dreset=1;
reg aes_ereset=1,aes_dreset=1;
reg reset = 1;
wire [1:0]done;
wire [1:0]E_D;
reg [127:0]operand;
reg [127:0]operand_e;
reg [255:0]operand_d;
reg [255:0]op;
reg [127:0]operand_ae;
reg [127:0]operand_ad;

reg [3:0]status=0;
reg reset_1;
//reg [4:0]status_d=0;
//reg [4:0]status_ae=0;
//reg [4:0]status_ad=0;
reg [127:0]buffer[8:0];
//reg [127:0]buffer_d[8:0];
//reg [127:0]buffer_ae[8:0];
//reg [127:0]buffer_ad[8:0];
integer i=0,j=0;
//jj=0,ii=0,i_ae=0,j_ae=0,i_ad=0,j_ad=0;
integer A = 0;
reg done_flag,flag;//flag is operation flag e.g RSA_Encryption_flag

wire AES_key_gen,private_key_gen;


/////////////////////////////////////////////////////////////KEYS//////////////////////////////////////////////////////////////////////
wire [127:0]RSA_private_key;// = 64'h0e33fd6f112faaa1;
reg [127:0]e = 128'd65537;
wire [127:0]N; // 64'd2727218023956295183;
wire [127:0]AES_key;
reg [127:0]key_rsa;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



always@(posedge Master_clk) begin
    if(E_D == 2'b10) begin
        done_flag = enc_flag;
        flag = RSA_Encryption_flag;
        rsa_ereset = reset_1;
        operand_e = operand;
        A = 1;
    end
    if(E_D == 2'b01) begin
        done_flag = dec_flag;
        flag = RSA_Decryption_flag;
        rsa_dreset = reset_1;
        operand_d = operand;
        A = 2;
    end
    if(ENCRYPT == 2'b10) begin
        done_flag = AES_Encryption_correct;
        flag = AES_Encryption_flag;
        aes_ereset = reset_1;
        operand_ae = operand;
        A = 3;
    end
    if(ENCRYPT == 2'b01) begin
        done_flag = AES_Decryption_correct;
        flag = AES_Decryption_flag;
        aes_dreset = reset_1;
        operand_ad = operand;
        A = 4;
    end   
end

always@(done_flag or flag or new_data)begin
    
    if(operand_1 == 1) begin
        reset_1 = 1;
        operand = 0;
        status = 13;
    end
    
    else begin
        if(done_flag == 0 && flag == 0 && new_data == 0) begin
            reset_1 = 1;
            operand = 0;
            status = 0;
            i = 0;
            j = 0;
        end
        else if(done_flag == 0 && flag == 1 && new_data == 0) begin
            if(status == 6) begin
                reset_1 = 1;
                operand = 0;
                status = 1;
            end
            if (status == 7) begin
                reset_1 = 0;
                operand = operand_1;
                status = 2;
            end
            if(status == 0 || status == 13 || status == 8) begin
                reset_1 = 0;
                operand = operand_1;
                status = 3;
            end
            if(status == 5 && j<i) begin
                reset_1 = 0;
                operand = buffer[j];
                j = j + 1;
                status = 4;
            end
                 
        end
        else if(done_flag == 1 && flag == 1 && new_data == 0) begin
             if(status == 10 || status == 4) begin
               reset_1 = 1;
               operand = 0; 
               status = 5;
            end
            else if(status == 11) begin
               reset_1 = 1;
               operand = 0;
               status = 5;
            end
            else begin
                reset_1 = 1;
                operand = 0;
                status = 6;
            end
        end
        else if(done_flag == 1 && flag == 1 && new_data == 1) begin
            reset_1 = 0;
            operand = operand_1;
            status = 7;
        end
        else if(done_flag == 0 && flag == 0 && new_data == 1) begin
            if(status == 0 || status == 13)begin
                reset_1 = 1;
                operand = 0;
                status = 8;
            end
        end
        else if(done_flag == 0 && flag == 1 && new_data == 1) begin
            if(status == 1) begin
                reset_1 = 0;
                operand = operand_1;
                status = 9;
            end
            if(status == 10) begin
                buffer[i] = operand_1; 
                i = i + 1;
                status = 10; 
            end
            if(status == 3) begin
                buffer[i] = operand_1; 
                i = i + 1;
                status = 10; 
            end
            if(status == 4) begin
                buffer[i] = operand_1;
                i = i + 1;
                status = 11;
            end
            
        end
        else begin
            reset_1 = 1;
            operand = 0;
        end
         
    end
end





always@(done or AES_Encryption_correct or AES_Decryption_correct)begin
    if((done == 2'b10 && E_D == 2'b10) || (done == 2'b01 && E_D == 2'b01))
        FINAL_OUTPUT = result[0];
    if(AES_Encryption_correct == 1 && ENCRYPT == 2'b10)
        FINAL_OUTPUT = OUT_ae[0];
    if(AES_Decryption_correct == 1 && ENCRYPT == 2'b01)
        FINAL_OUTPUT = OUT_ad[0];    
end


assign enc_flag = (done & 2'b10) >> 1;
assign dec_flag = done & 2'b01;

always@(*)begin
    if(E_D == 2'b10) begin
        reset = rsa_ereset;
        op = operand_e;
        key_rsa = e;
    end
    else if(E_D == 2'b01)begin
        reset = rsa_dreset;   
        op = operand_d;
        key_rsa = RSA_private_key;
    end     
end

RSA_d_e reset_dec(RSA_Encryption_flag,RSA_Decryption_flag,E_D/*,done,operand,operand_d,op,enc_flag,dec_flag*/);
AES_d_e reset_decider(AES_Encryption_flag,AES_Decryption_flag,ENCRYPT/*,aes_ereset,aes_dreset*/);

Key_generator keygen(Master_clk,Master_reset,randomize,AES_key_new,private_key_new,AES_key_gen,private_key_gen,RSA_private_key,AES_key,N);

RSA_enc_dec RSA(Master_clk,reset,done,op,result,key_rsa,N,E_D);
//RSA_Encryptor RSA_ENC(operand,ciphertext,Master_clk,rsa_ereset,enc_flag,RSA_Encryption_flag);
//RSA_Decryptor RSA_DEC(operand_d,aes_keyin_decrypted,Master_clk,rsa_dreset,dec_flag,RSA_Decryption_flag);


AES U1_Encrypt(Master_clk,AES_Encryption_correct,AES_Encryption_wrong,ENCRYPT,aes_ereset,1'b1,operand_ae,OUT_ae,AES_key);
AES U1_Decrypt(Master_clk,AES_Decryption_correct,AES_Decryption_wrong,ENCRYPT,aes_dreset,1'b0,operand_ad,OUT_ad,AES_key);



endmodule




