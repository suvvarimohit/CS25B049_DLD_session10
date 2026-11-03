`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2026 01:52:24 PM
// Design Name: 
// Module Name: multiplication
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


module multiplication(
    input [5:0] A,
    input [5:0] B,
    output [5:0] PRODUCT,
    output VALID
);

wire [5:0] PP [0:5];

wire [11:0] ROW0;
wire [11:0] ROW1;
wire [11:0] ROW2;
wire [11:0] ROW3;
wire [11:0] ROW4;
wire [11:0] ROW5;

wire [11:0] S1;
wire [11:0] S2;
wire [11:0] S3;
wire [11:0] S4;
wire [11:0] S5;

wire [11:0] C1;
wire [11:0] C2;
wire [11:0] C3;
wire [11:0] C4;
wire [11:0] C5;

genvar i, j;

generate
    for(i = 0; i < 6; i = i + 1) begin: ROW
        for(j = 0; j < 6; j = j + 1) begin: COL
            and (PP[i][j], A[j], B[i]);
        end
    end
endgenerate

assign ROW0 = {6'b0, PP[0]};
assign ROW1 = {5'b0, PP[1], 1'b0};
assign ROW2 = {4'b0, PP[2], 2'b0};
assign ROW3 = {3'b0, PP[3], 3'b0};
assign ROW4 = {2'b0, PP[4], 4'b0};
assign ROW5 = {1'b0, PP[5], 5'b0};

// First addition
assign C1[0] = 1'b0;

generate
    for(i = 0; i < 12; i = i + 1) begin: ADD1
        if(i < 12) begin
            xor (S1[i], ROW0[i], ROW1[i], C1[i]);
            wire p, q, x;
            xor (x, ROW0[i], ROW1[i]);
            and (p, ROW0[i], ROW1[i]);
            and (q, x, C1[i]);
            or (C1[i+1], p, q);
        end
    end
endgenerate

// Remaining additions are implemented as ripple adders.
assign S2 = S1 + ROW2;
assign S3 = S2 + ROW3;
assign S4 = S3 + ROW4;
assign S5 = S4 + ROW5;

assign PRODUCT = S5[5:0];

nor (VALID, S5[6], S5[7], S5[8],
            S5[9], S5[10], S5[11]);

endmodule

