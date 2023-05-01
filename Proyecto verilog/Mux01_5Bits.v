`timescale 1ns/1ns
/* El primer input es el que se devuelve si el 
selector tienen 1'b1 de valor */
module Mux01_5Bits (
    input [4:0] valOnSel0, 
    input [4:0] valOnSel1, 
    input selector,
    output reg [4:0]dataOut
);

    always @(selector) begin
        dataOut <= selector == 1'b1 
                    ? valOnSel1
                    : valOnSel0;
    end
endmodule //Mux01