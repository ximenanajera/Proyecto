`timescale 1ns/1ns
module Mux01_31Bits (
    input [31:0] valOnSel0, 
    input [31:0] valOnSel1, 
    input selector,
    output reg [31:0]dataOut
);

    assign dataOut = selector == 1'b1 
                    ? valOnSel1
                    : valOnSel0;
    
endmodule //Mux01
