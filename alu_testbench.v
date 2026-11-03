`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2026 01:54:25 PM
// Design Name: 
// Module Name: alu_testbench
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


module alu_testbench;

reg [5:0] A;
reg [5:0] B;
reg [2:0] SEL;

wire [5:0] RESULT;
wire VALID;
wire [1:0] CMP;

alu_top DUT(
    .A(A),
    .B(B),
    .SEL(SEL),
    .RESULT(RESULT),
    .VALID(VALID),
    .CMP(CMP)
);

initial begin

    A = 6'd10;
    B = 6'd5;

    SEL = 3'b000;
    #10;

    SEL = 3'b001;
    #10;

    SEL = 3'b010;
    #10;

    SEL = 3'b011;
    #10;

    SEL = 3'b100;
    #10;

    SEL = 3'b101;
    #10;

    SEL = 3'b110;
    #10;

    A = 6'd50;
    B = 6'd30;

    SEL = 3'b000;
    #10;

    SEL = 3'b001;
    #10;

    SEL = 3'b101;
    #10;

    A = 6'd20;
    B = 6'd30;

    SEL = 3'b110;
    #10;

    $finish;

end

endmodule
