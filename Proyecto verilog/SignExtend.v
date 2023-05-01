`timescale 1ns/1ns
module SignExtend (
    input [15:0] inputBits,
    output [31:0] extendedBits
);
    assign extendedBits = {16'b1111111111111111, inputBits};
endmodule //SignExtend