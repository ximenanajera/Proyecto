`timescale 1ns/1ns
module Adder (
    input [31:0] add,
    input [31:0] originalNumber,
    output [31:0] out
);
    assign out = originalNumber + add;
endmodule