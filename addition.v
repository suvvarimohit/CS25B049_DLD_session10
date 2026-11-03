`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2026 01:50:46 PM
// Design Name: 
// Module Name: addition
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


module addition(
    input [5:0] A,
    input [5:0] B,
    output [5:0] SUM,
    output VALID
);

wire [6:0] C;
wire [6:0] X;
wire [6:0] P;
wire [6:0] Q;

assign C[0] = 1'b0;

genvar i;
generate
    for(i = 0; i < 6; i = i + 1) begin: ADDER
        xor (X[i], A[i], B[i]);
        xor (SUM[i], X[i], C[i]);

        and (P[i], A[i], B[i]);
        and (Q[i], X[i], C[i]);

        or (C[i+1], P[i], Q[i]);
    end
endgenerate

assign C[6] = 1'b0;

assign VALID = ~C[6];

endmodule

