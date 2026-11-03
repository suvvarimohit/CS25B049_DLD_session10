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



module alu_top(
    input [5:0] A,
    input [5:0] B,
    input [2:0] SEL,
    input clk,
    output reg [5:0] RESULT,
    output reg VALID,
    output reg [1:0] CMP,
    output reg [3:0] D0_AN,
    output reg [7:0] D0_SEG,
    output reg [3:0] D1_AN,
    output reg [7:0] D1_SEG
);

wire [5:0] sum;
wire [5:0] diff;
wire [5:0] and_out;
wire [5:0] or_out;
wire [5:0] not_out;
wire [5:0] mul_out;

wire add_valid;
wire sub_valid;
wire mul_valid;

wire [1:0] cmp_out;

reg signed [13:0] display_value;
reg [13:0] magnitude;

reg [3:0] thousands;
reg [3:0] hundreds;
reg [3:0] tens;
reg [3:0] ones;

reg negative;

reg [17:0] refresh_counter;
wire [1:0] scan;

reg [3:0] current_digit;

assign scan = refresh_counter[17:16];

addition U1(A, B, sum, add_valid);
subtraction U2(A, B, diff, sub_valid);
bitwise_and U3(A, B, and_out);
bitwise_or U4(A, B, or_out);
bitwise_not U5(A, not_out);
multiplication U6(A, B, mul_out, mul_valid);
comparator U7(A, B, cmp_out);


// ALU operation selection
always @(*) begin
    RESULT = 6'b000000;
    VALID = 1'b1;
    CMP = 2'b00;
    display_value = 14'sd0;

    case(SEL)

        3'b000: begin
            RESULT = sum;
            VALID = add_valid;
            display_value = $signed({8'b0, A}) +
                            $signed({8'b0, B});
        end

        3'b001: begin
            RESULT = diff;
            VALID = sub_valid;
            display_value = $signed({8'b0, A}) -
                            $signed({8'b0, B});
        end

        3'b010: begin
            RESULT = and_out;
            display_value = {8'b0, and_out};
        end

        3'b011: begin
            RESULT = or_out;
            display_value = {8'b0, or_out};
        end

        3'b100: begin
            RESULT = not_out;
            display_value = {8'b0, not_out};
        end

        3'b101: begin
            RESULT = mul_out;
            VALID = mul_valid;
            display_value = A * B;
        end

        3'b110: begin
            CMP = cmp_out;

            if(cmp_out == 2'b00)
                display_value = 14'd0;
            else if(cmp_out == 2'b01)
                display_value = 14'd1;
            else
                display_value = 14'd2;
        end

        default: begin
            RESULT = 6'b000000;
            VALID = 1'b0;
            CMP = 2'b00;
            display_value = 14'd0;
        end

    endcase
end


// Convert ALU output into decimal digits
always @(*) begin
    negative = 1'b0;
    magnitude = 14'd0;

    if(display_value < 0) begin
        negative = 1'b1;
        magnitude = -display_value;
    end
    else begin
        magnitude = display_value;
    end

    thousands = magnitude / 1000;
    hundreds = (magnitude / 100) % 10;
    tens = (magnitude / 10) % 10;
    ones = magnitude % 10;
end


// Clock divider for display scanning
always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1'b1;
end


// Seven-segment decoder
function [7:0] sevenseg;
    input [3:0] digit;

    begin
        case(digit)

            4'd0: sevenseg = 8'b11000000;
            4'd1: sevenseg = 8'b11111001;
            4'd2: sevenseg = 8'b10100100;
            4'd3: sevenseg = 8'b10110000;
            4'd4: sevenseg = 8'b10011001;
            4'd5: sevenseg = 8'b10010010;
            4'd6: sevenseg = 8'b10000010;
            4'd7: sevenseg = 8'b11111000;
            4'd8: sevenseg = 8'b10000000;
            4'd9: sevenseg = 8'b10010000;

            // Minus sign
            4'hA: sevenseg = 8'b10111111;

            // Blank
            default: sevenseg = 8'b11111111;

        endcase
    end
endfunction


// Display control
always @(*) begin

    // Turn OFF the entire left display
    D0_AN = 4'b1111;
    D0_SEG = 8'b11111111;

    // Default right display
    D1_AN = 4'b1111;
    D1_SEG = 8'b11111111;

    current_digit = 4'hF;

    case(scan)

        // Ones position
        2'b00: begin
            D1_AN = 4'b1110;
            current_digit = ones;
        end

        // Tens position
        2'b01: begin
            D1_AN = 4'b1101;

            if(magnitude >= 10)
                current_digit = tens;
            else
                current_digit = 4'hF;
        end

        // Hundreds position
        2'b10: begin
            D1_AN = 4'b1011;

            if(negative)
                current_digit = 4'hF;
            else if(magnitude >= 100)
                current_digit = hundreds;
            else
                current_digit = 4'hF;
        end

        // Thousands position or minus sign
        2'b11: begin
            D1_AN = 4'b0111;

            if(negative)
                current_digit = 4'hA;
            else if(magnitude >= 1000)
                current_digit = thousands;
            else
                current_digit = 4'hF;
        end

    endcase

    D1_SEG = sevenseg(current_digit);

end

endmodule
