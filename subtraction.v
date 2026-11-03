`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2026 01:51:14 PM
// Design Name: 
// Module Name: subtraction
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


module subtraction(
    input [5:0] A,
    input [5:0] B,
    output [5:0] DIFF,
    output VALID
);

wire [5:0] B_INV;
wire [6:0] C;
wire [5:0] X;
wire [5:0] P;
wire [5:0] Q;

not (B_INV[0], B[0]);
not (B_INV[1], B[1]);
not (B_INV[2], B[2]);
not (B_INV[3], B[3]);
not (B_INV[4], B[4]);
not (B_INV[5], B[5]);

assign C[0] = 1'b1;

genvar i;
generate
    for(i = 0; i < 6; i = i + 1) begin: SUBTRACTOR
        xor (X[i], A[i], B_INV[i]);
        xor (DIFF[i], X[i], C[i]);

        and (P[i], A[i], B_INV[i]);
        and (Q[i], X[i], C[i]);

        or (C[i+1], P[i], Q[i]);
    end
endgenerate

assign VALID = C[6];

endmodule

