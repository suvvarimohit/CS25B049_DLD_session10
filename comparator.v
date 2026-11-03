`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2026 01:52:57 PM
// Design Name: 
// Module Name: comparator
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

module comparator(
    input [5:0] A,
    input [5:0] B,
    output reg [1:0] CMP
);

wire [5:0] DIFF;
wire VALID;
wire EQUAL;
wire GREATER;
wire SMALLER;

subtraction SUB1(A, B, DIFF, VALID);

nor (EQUAL, DIFF[0], DIFF[1], DIFF[2],
              DIFF[3], DIFF[4], DIFF[5]);

and (GREATER, VALID, ~EQUAL);
not (SMALLER, VALID);

always @(*) begin
    if(EQUAL)
        CMP = 2'b00;
    else if(GREATER)
        CMP = 2'b01;
    else
        CMP = 2'b10;
end

endmodule

